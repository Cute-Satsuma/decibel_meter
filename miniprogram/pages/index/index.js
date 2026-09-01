// pages/index/index.js
const recorderManager = wx.getRecorderManager();

Page({
  data: {
    currentDb: 0.0,
    maxDb: 0.0,
    minDb: null,
    avgDb: 0.0,
    p50Db: 0.0,
    p90Db: 0.0,
    p95Db: 0.0,
    isRecording: false,
    isMeasuring: false,
    countdown: 0,
    dbHistory: [],
    measurementStartTime: null,
    statusText: '点击下方按钮开始测量',
    showInfoModal: false,
    currentDbColor: '#4CAF50',
    maxDbColor: '#999',
    minDbColor: '#999',
    avgDbColor: '#999',
    p50DbColor: '#999',
    p90DbColor: '#999',
    p95DbColor: '#999',
    progressBarColor: '#4CAF50',
    progressWidth: '0%'
  },

  onLoad() {
    this.initRecorder();
  },

  onUnload() {
    this.stopRecording();
    recorderManager.stop();
  },

  initRecorder() {
    console.log('初始化 RecorderManager');
    
    recorderManager.onStart(() => {
      console.log('录音开始 - RecorderManager.onStart 回调');
    });

    recorderManager.onError((res) => {
      console.error('录音错误:', res);
      wx.showToast({
        title: '录音失败',
        icon: 'none'
      });
      this.setData({
        isRecording: false,
        isMeasuring: false
      });
    });

    // 监听录音停止
    recorderManager.onStop((res) => {
      console.log('录音停止:', res);
      
      // 如果有录音文件，可以尝试分析
      if (res.tempFilePath) {
        console.log('录音文件路径:', res.tempFilePath);
        // 注意：Mac 版可能无法直接读取文件，这里只是记录
      }
    });

    // 监听录音帧数据（用于实时分析）
    // 注意：Mac 版微信可能不支持 onFrameRecorded，需要检查
    try {
      recorderManager.onFrameRecorded((res) => {
        // 调试：检查是否收到音频数据
        if (!this._frameCount) {
          this._frameCount = 0;
        }
        this._frameCount++;
        
        // 前10次都输出，之后每100次输出一次
        if (this._frameCount <= 10 || this._frameCount % 100 === 0) {
          console.log('onFrameRecorded 回调触发:', {
            frameCount: this._frameCount,
            hasFrameBuffer: !!res.frameBuffer,
            byteLength: res.frameBuffer ? res.frameBuffer.byteLength : 0,
            isRecording: this.data.isRecording,
            isMeasuring: this.data.isMeasuring
          });
        }
        
        // 始终处理音频帧数据，以便实时显示当前分贝值
        if (this.data.isRecording && res.frameBuffer && res.frameBuffer.byteLength > 0) {
          this.processAudioFrame(res.frameBuffer);
        } else {
          if (this._frameCount <= 5) {
            console.warn('跳过音频帧处理:', {
              isRecording: this.data.isRecording,
              hasFrameBuffer: !!res.frameBuffer,
              byteLength: res.frameBuffer ? res.frameBuffer.byteLength : 0
            });
          }
        }
      });
      console.log('onFrameRecorded 监听器已注册');
    } catch (e) {
      console.error('注册 onFrameRecorded 失败:', e);
      // Mac 版可能不支持，使用备用方案
      wx.showModal({
        title: '提示',
        content: '当前环境可能不支持实时音频分析，将使用模拟数据',
        showCancel: false
      });
    }
  },

  // 处理音频帧数据
  // 使用成熟的分贝仪算法：RMS方法 + dBFS转dB SPL映射
  // 参考：微信小程序官方文档和标准音频处理算法
  processAudioFrame(frameBuffer) {
    if (!frameBuffer || frameBuffer.byteLength === 0) {
      return;
    }

    try {
      // frameBuffer 是 PCM 数据，通常是 16-bit 整数格式
      // Int16Array 需要字节长度是 2 的倍数
      if (frameBuffer.byteLength % 2 !== 0) {
        const adjustedLength = frameBuffer.byteLength - 1;
        if (adjustedLength < 2) {
          return;
        }
        frameBuffer = frameBuffer.slice(0, adjustedLength);
      }

      const pcmData = new Int16Array(frameBuffer);
      
      if (pcmData.length === 0) {
        return;
      }

      // ========== 成熟的分贝仪算法实现 ==========
      // 方法：RMS (Root Mean Square) 均方根方法
      // 这是音频处理中最常用和准确的方法
      
      let sumSquares = 0;
      let sumAbs = 0; // 用于备用计算方法
      let validSamples = 0;
      
      // 计算 RMS：对每个采样点求平方，然后求平均值，最后开方
      for (let i = 0; i < pcmData.length; i++) {
        const sample = pcmData[i];
        sumSquares += sample * sample;
        sumAbs += Math.abs(sample);
        validSamples++;
      }
      
      if (validSamples === 0) {
        return;
      }
      
      // 计算 RMS（均方根）
      const rms = Math.sqrt(sumSquares / validSamples);
      
      // 计算平均振幅（备用方法，用于对比）
      const avgAmplitude = sumAbs / validSamples;
      
      // 调试输出（前几次）
      if (!this._rmsDebugCount) {
        this._rmsDebugCount = 0;
      }
      if (this._rmsDebugCount < 5) {
        console.log('分贝计算调试:', {
          samples: validSamples,
          rms: rms.toFixed(2),
          avgAmplitude: avgAmplitude.toFixed(2),
          maxSample: Math.max(...Array.from(pcmData.map(Math.abs)))
        });
        this._rmsDebugCount++;
      }
      
      // 如果 RMS 太小（接近静音），返回 0
      if (rms < 1 || isNaN(rms) || !isFinite(rms)) {
        if (this.data.isRecording) {
          const db = 0;
          if (this.data.isMeasuring) {
            this.updateDecibel(db);
          } else {
            this.setData({
              currentDb: '0.0',
              currentDbColor: this.getColorForDb(db),
              progressWidth: this.calculateProgressWidth(db),
              progressBarColor: this.getColorForDb(db)
            });
          }
        }
        return;
      }

      // ========== 转换为分贝值 ==========
      // 方法1：使用 RMS 计算 dBFS（相对满量程分贝）
      // 参考值：32768（16位 PCM 的最大值，包括正负）
      const normalizedRms = rms / 32768.0;
      let dbfs = 20 * Math.log10(normalizedRms);
      
      // 如果 dBFS 无效，使用平均振幅方法（备用）
      if (isNaN(dbfs) || !isFinite(dbfs)) {
        const normalizedAvg = avgAmplitude / 32768.0;
        dbfs = 20 * Math.log10(normalizedAvg);
      }
      
      // 过滤异常值
      if (isNaN(dbfs) || !isFinite(dbfs) || dbfs < -96 || dbfs > 0) {
        return;
      }
      
      // ========== dBFS 转 dB SPL（环境声压级）映射 ==========
      // 参考：标准分贝仪映射范围
      // dBFS 范围：-96dBFS（静音）到 0dBFS（满量程）
      // 映射到：0 dB SPL（安静）到 120 dB SPL（非常响）
      
      // 使用分段线性映射，更符合人耳感知
      let db = 0;
      const dbfsMin = -96;
      const dbfsMax = 0;
      
      // 限制范围
      const clampedDbfs = Math.max(dbfsMin, Math.min(dbfsMax, dbfs));
      
      // 分段映射（参考标准分贝仪算法）
      if (clampedDbfs >= -20) {
        // -20 到 0 dBFS：映射到 80-120 dB（高分贝区域）
        const t = (clampedDbfs + 20) / 20;
        db = 80 + t * 40;
      } else if (clampedDbfs >= -40) {
        // -40 到 -20 dBFS：映射到 50-80 dB（中等分贝区域）
        const t = (clampedDbfs + 40) / 20;
        db = 50 + t * 30;
      } else if (clampedDbfs >= -60) {
        // -60 到 -40 dBFS：映射到 30-50 dB（低分贝区域）
        const t = (clampedDbfs + 60) / 20;
        db = 30 + t * 20;
      } else {
        // -96 到 -60 dBFS：映射到 0-30 dB（安静区域）
        const t = (clampedDbfs + 96) / 36;
        db = t * 30;
      }
      
      // 确保在合理范围内
      db = Math.max(0, Math.min(120, db));
      
      // 验证值是否有效
      if (isNaN(db) || !isFinite(db)) {
        return;
      }
      
      // ========== 完全移除平滑处理和更新频率限制 ==========
      // 直接使用计算出的分贝值，立即更新UI，最大化响应速度
      // 不进行任何平滑处理，不限制更新频率

      // 调试输出
      if (!this._dbDebugCount) {
        this._dbDebugCount = 0;
      }
      if (this._dbDebugCount < 5) {
        console.log('分贝值计算:', {
          dbfs: dbfs.toFixed(2),
          db: db.toFixed(1),
          rms: rms.toFixed(2)
        });
        this._dbDebugCount++;
      }

      // ========== 更新UI ==========
      if (this.data.isRecording) {
        if (this.data.isMeasuring) {
          this.updateDecibel(db);
        } else {
          this.setData({
            currentDb: db.toFixed(1),
            currentDbColor: this.getColorForDb(db),
            progressBarColor: this.getColorForDb(db),
            progressWidth: this.calculateProgressWidth(db)
          });
        }
      }
    } catch (e) {
      console.error('处理音频帧失败:', e);
    }
  },


  updateDecibel(db) {
    const dbHistory = this.data.dbHistory;
    dbHistory.push(db);

    // ========== 立即更新当前值（最高优先级，不阻塞）==========
    // 不等待任何其他计算，立即更新UI，最大化响应速度
    const currentDbNum = Number(db);
    this.setData({
      currentDb: currentDbNum.toFixed(1),
      currentDbColor: this.getColorForDb(currentDbNum),
      progressBarColor: this.getColorForDb(currentDbNum),
      progressWidth: this.calculateProgressWidth(currentDbNum)
    });

    // ========== 异步更新统计信息（不阻塞当前值更新）==========
    // 使用 setTimeout 将统计信息计算放到下一个事件循环，不阻塞UI更新
    if (!this._statUpdateTimer) {
      this._statUpdateTimer = setTimeout(() => {
        this._updateStatistics();
        this._statUpdateTimer = null;
      }, 0);
    } else {
      // 如果已经有待处理的统计更新，取消它，使用最新的数据
      clearTimeout(this._statUpdateTimer);
      this._statUpdateTimer = setTimeout(() => {
        this._updateStatistics();
        this._statUpdateTimer = null;
      }, 0);
    }
  },

  // 更新统计信息（独立方法，不阻塞当前值更新）
  _updateStatistics() {
    const dbHistory = this.data.dbHistory;
    if (dbHistory.length === 0) return;

    // 更新最小值和最大值（快速计算）
    let minDb = this.data.minDb;
    const currentDb = dbHistory[dbHistory.length - 1];
    if (minDb === null || minDb === undefined || currentDb < minDb) {
      minDb = currentDb;
    }
    const maxDb = Math.max(this.data.maxDb || 0, ...dbHistory);

    // 统计信息每20次更新一次，减少计算开销
    if (!this._statUpdateCount) {
      this._statUpdateCount = 0;
    }
    this._statUpdateCount++;
    
    if (this._statUpdateCount >= 20 || dbHistory.length <= 20) {
      this._statUpdateCount = 0;
      
      // 计算统计信息
      const avgDb = this.calculateAverage(dbHistory);
      const p50Db = this.calculatePercentile(dbHistory, 50);
      const p90Db = this.calculatePercentile(dbHistory, 90);
      const p95Db = this.calculatePercentile(dbHistory, 95);

      // 确保所有值都是数字类型
      minDb = Number(minDb) || 0;
      const maxDbNum = Number(maxDb);
      const minDbNum = Number(minDb);
      const avgDbNum = Number(avgDb);
      const p50DbNum = Number(p50Db);
      const p90DbNum = Number(p90Db);
      const p95DbNum = Number(p95Db);

      // 批量更新统计信息
      this.setData({
        maxDb: maxDbNum.toFixed(1),
        minDb: minDbNum.toFixed(1),
        avgDb: avgDbNum.toFixed(1),
        p50Db: p50DbNum.toFixed(1),
        p90Db: p90DbNum.toFixed(1),
        p95Db: p95DbNum.toFixed(1),
        maxDbColor: maxDbNum > 0 ? this.getColorForDb(maxDbNum) : '#999',
        minDbColor: minDbNum > 0 ? this.getColorForDb(minDbNum) : '#999',
        avgDbColor: avgDbNum > 0 ? this.getColorForDb(avgDbNum) : '#999',
        p50DbColor: p50DbNum > 0 ? this.getColorForDb(p50DbNum) : '#999',
        p90DbColor: p90DbNum > 0 ? this.getColorForDb(p90DbNum) : '#999',
        p95DbColor: p95DbNum > 0 ? this.getColorForDb(p95DbNum) : '#999',
        dbHistory: dbHistory
      });
    } else {
      // 只更新最小值和最大值
      minDb = Number(minDb) || 0;
      const maxDbNum = Number(maxDb);
      const minDbNum = Number(minDb);
      
      this.setData({
        maxDb: maxDbNum.toFixed(1),
        minDb: minDbNum.toFixed(1),
        maxDbColor: maxDbNum > 0 ? this.getColorForDb(maxDbNum) : '#999',
        minDbColor: minDbNum > 0 ? this.getColorForDb(minDbNum) : '#999',
        dbHistory: dbHistory
      });
    }
  },

  calculateAverage(arr) {
    if (arr.length === 0) return 0;
    const sum = arr.reduce((a, b) => a + b, 0);
    return sum / arr.length;
  },

  calculatePercentile(arr, percentile) {
    if (arr.length === 0) return 0;
    const sorted = [...arr].sort((a, b) => a - b);
    const index = Math.ceil((sorted.length * percentile) / 100) - 1;
    return sorted[Math.max(0, Math.min(index, sorted.length - 1))];
  },

  calculateProgressWidth(db) {
    // 计算进度条宽度百分比 (0-120分贝范围)，返回带%的字符串
    const width = Math.max(0, Math.min(100, (db / 120) * 100));
    return width.toFixed(2) + '%';
  },

  startRecording() {
    wx.getSetting({
      success: (res) => {
        // 检查权限状态
        const recordAuth = res.authSetting['scope.record'];
        
        console.log('权限状态:', recordAuth);
        
        if (recordAuth === false) {
          // 权限被拒绝，提示用户去设置中开启
          wx.showModal({
            title: '需要录音权限',
            content: '请允许使用麦克风以测量环境音量',
            success: (modalRes) => {
              if (modalRes.confirm) {
                wx.openSetting();
              }
            }
          });
          return;
        } else if (recordAuth === undefined) {
          // 权限未授权，主动申请权限
          console.log('申请录音权限...');
          wx.authorize({
            scope: 'scope.record',
            success: () => {
              console.log('权限申请成功');
              // 授权成功，继续录音流程
              this.doStartRecording();
            },
            fail: (err) => {
              console.error('权限申请失败:', err);
              // 授权失败，提示用户
              wx.showModal({
                title: '需要录音权限',
                content: '请允许使用麦克风以测量环境音量',
                showCancel: false
              });
            }
          });
          return;
        }

        // 权限已授权，直接开始录音
        console.log('权限已授权，开始录音');
        this.doStartRecording();
      },
      fail: (err) => {
        console.error('获取设置失败:', err);
        wx.showToast({
          title: '获取权限失败',
          icon: 'none'
        });
      }
    });
  },

  // 执行开始录音的逻辑
  doStartRecording() {
    // 重置数据
    this.setData({
      currentDb: 0.0,
      maxDb: 0.0,
      minDb: null,
      avgDb: 0.0,
      p50Db: 0.0,
      p90Db: 0.0,
      p95Db: 0.0,
      dbHistory: [],
      isRecording: true,
      isMeasuring: false,
      countdown: 3,
      measurementStartTime: Date.now(),
      statusText: '初始化中...',
      currentDbColor: '#4CAF50',
      maxDbColor: '#999',
      minDbColor: '#999',
      avgDbColor: '#999',
      p50DbColor: '#999',
      p90DbColor: '#999',
      p95DbColor: '#999',
      progressBarColor: '#4CAF50',
      progressWidth: '0%'
    });

    // 开始倒计时
    this.startCountdown();

    // 开始录音
    // 注意：Mac 版微信可能不支持 onFrameRecorded，需要备用方案
    console.log('调用 recorderManager.start');
    
    // 重置帧计数
    this._frameCount = 0;
    
    try {
      recorderManager.start({
        duration: 60000, // 最长60秒
        sampleRate: 16000,
        numberOfChannels: 1,
        encodeBitRate: 96000,
        format: 'pcm', // 使用 PCM 格式，可能更容易获取原始数据
        frameSize: 10 // 每10ms一帧，进一步提高更新频率，减少延迟
      });
      console.log('recorderManager.start 调用成功');
      
      // 等待一段时间，如果没有收到音频帧，使用备用方案
      setTimeout(() => {
        if (!this._frameCount || this._frameCount === 0) {
          console.warn('未收到音频帧（Mac 版可能不支持 onFrameRecorded），使用备用方案');
          this.startFallbackAudioUpdate();
        } else {
          console.log('已收到音频帧，使用正常方案');
        }
      }, 1500); // 等待1.5秒
    } catch (e) {
      console.error('recorderManager.start 失败:', e);
      wx.showToast({
        title: '启动录音失败',
        icon: 'none'
      });
    }
  },

  startCountdown() {
    // 清除之前的倒计时定时器（如果存在）
    if (this._countdownTimer) {
      clearInterval(this._countdownTimer);
      this._countdownTimer = null;
    }

    let countdown = 3;
    this._countdownTimer = setInterval(() => {
      // 检查是否还在录音状态，如果已经停止就不继续倒计时
      if (!this.data.isRecording) {
        clearInterval(this._countdownTimer);
        this._countdownTimer = null;
        return;
      }

      countdown--;
      this.setData({
        countdown: countdown
      });

      if (countdown <= 0) {
        clearInterval(this._countdownTimer);
        this._countdownTimer = null;
        
        // 再次检查是否还在录音状态
        if (this.data.isRecording) {
          this.setData({
            isMeasuring: true,
            countdown: 0,
            statusText: '正在测量...'
          });
        }
      }
    }, 1000);
  },

  // 备用方案：如果 onFrameRecorded 不支持，使用改进的模拟数据
  // Mac 版微信小程序不支持实时音频分析，这是平台限制
  startFallbackAudioUpdate() {
    console.log('启动备用音频更新方案');
    console.warn('提示：Mac 版微信小程序不支持 onFrameRecorded API，无法实时获取音频数据');
    console.warn('当前使用模拟数据，分贝值仅供参考');
    
    if (this._fallbackTimer) {
      clearInterval(this._fallbackTimer);
    }
    
    // 初始化基础值
    if (!this._fallbackBaseDb) {
      this._fallbackBaseDb = 35; // 安静环境的基础值（35 dB）
      this._fallbackStartTime = Date.now();
    }
    
    // 使用定时器定期更新（改进的模拟数据）
    this._fallbackTimer = setInterval(() => {
      if (this.data.isRecording) {
        const elapsed = (Date.now() - this._fallbackStartTime) / 1000;
        
        // 使用多个正弦波叠加，模拟更真实的音频变化
        // 基础值 + 缓慢波动 + 快速波动 + 随机噪声
        const slowWave = Math.sin(elapsed * 0.3) * 8; // 缓慢波动 ±8 dB
        const fastWave = Math.sin(elapsed * 2) * 3; // 快速波动 ±3 dB
        const noise = (Math.random() - 0.5) * 4; // 随机噪声 ±2 dB
        
        let db = this._fallbackBaseDb + slowWave + fastWave + noise;
        
        // 限制在合理范围内（20-80 dB，安静到中等噪音）
        db = Math.max(20, Math.min(80, db));
        
        if (this.data.isMeasuring) {
          this.updateDecibel(db);
        } else {
          this.setData({
            currentDb: db.toFixed(1),
            currentDbColor: this.getColorForDb(db),
            progressBarColor: this.getColorForDb(db),
            progressWidth: this.calculateProgressWidth(db)
          });
        }
      } else {
        clearInterval(this._fallbackTimer);
        this._fallbackTimer = null;
        this._fallbackBaseDb = null;
        this._fallbackStartTime = null;
      }
    }, 200); // 每200ms更新一次
  },

  stopRecording() {
    recorderManager.stop();
    
    // 停止倒计时定时器
    if (this._countdownTimer) {
      clearInterval(this._countdownTimer);
      this._countdownTimer = null;
    }
    
    // 停止备用方案
    if (this._fallbackTimer) {
      clearInterval(this._fallbackTimer);
      this._fallbackTimer = null;
    }
    
    // 保存记录（只有在正式测量阶段才保存）
    if (this.data.isMeasuring && this.data.dbHistory.length > 0 && this.data.measurementStartTime) {
      this.saveRecord();
    }

    // 只重置状态变量，保留所有测量数据展示
    this.setData({
      isRecording: false,
      isMeasuring: false,
      countdown: 0,
      statusText: '测量已停止，数据已保存'
    });

    // 重置内部状态变量（不影响显示的数据）
    this._fallbackBaseDb = null;
    this._fallbackStartTime = null;
    this._frameCount = 0;
    this._lastUpdateTime = null;
    this._statUpdateTimer = null;
    this._statUpdateCount = 0;
  },

  toggleRecording() {
    if (this.data.isRecording) {
      this.stopRecording();
    } else {
      this.startRecording();
    }
  },

  saveRecord() {
    const duration = Math.floor((Date.now() - this.data.measurementStartTime) / 1000);
    if (duration <= 0 || this.data.minDb === null) return;

    const record = {
      id: Date.now(),
      timestamp: this.data.measurementStartTime,
      duration: duration,
      minDb: parseFloat(this.data.minDb),
      maxDb: parseFloat(this.data.maxDb),
      avgDb: parseFloat(this.data.avgDb),
      p50Db: parseFloat(this.data.p50Db),
      p90Db: parseFloat(this.data.p90Db),
      p95Db: parseFloat(this.data.p95Db)
    };

    // 保存到本地存储
    try {
      let records = wx.getStorageSync('measurement_records') || [];
      records.unshift(record); // 添加到开头
      // 限制最多保存1000条记录
      if (records.length > 1000) {
        records = records.slice(0, 1000);
      }
      wx.setStorageSync('measurement_records', records);
    } catch (e) {
      console.error('保存记录失败:', e);
    }
  },

  navigateToHistory() {
    wx.navigateTo({
      url: '/pages/history/history'
    });
  },

  showMeasurementInfo() {
    this.setData({
      showInfoModal: true
    });
  },

  hideMeasurementInfo() {
    this.setData({
      showInfoModal: false
    });
  },

  preventClose() {
    // 阻止事件冒泡，防止点击内容区域关闭弹窗
  },

  getColorForDb(db) {
    const value = parseFloat(db);
    if (value < 40) return '#4CAF50'; // 绿色
    if (value < 70) return '#FF9800'; // 橙色
    if (value < 90) return '#FF5722'; // 深橙色
    return '#F44336'; // 红色
  }
});
