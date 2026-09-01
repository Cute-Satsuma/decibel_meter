// app.js
App({
  onLaunch() {
    // 初始化应用
    console.log('dB Meter Caju 启动');
    
    // 检查录音权限
    this.checkRecordPermission();
  },

  checkRecordPermission() {
    wx.getSetting({
      success: (res) => {
        if (!res.authSetting['scope.record']) {
          // 引导用户授权
          wx.authorize({
            scope: 'scope.record',
            success: () => {
              console.log('录音权限已授权');
            },
            fail: () => {
              console.log('录音权限未授权');
            }
          });
        }
      }
    });
  },

  globalData: {
    language: 'zh_CN', // 默认语言
  }
});
