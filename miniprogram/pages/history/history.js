// pages/history/history.js
Page({
  data: {
    records: [],
    isLoading: false,
    hasMore: true,
    page: 0,
    pageSize: 20
  },

  onLoad() {
    this.loadRecords();
  },

  onShow() {
    // 每次显示页面时刷新数据
    this.loadRecords();
  },

  onPullDownRefresh() {
    // 下拉刷新
    this.loadRecords();
    wx.stopPullDownRefresh();
  },

  onReachBottom() {
    // 滚动到底部加载更多
    if (!this.data.isLoading && this.data.hasMore) {
      this.loadMoreRecords();
    }
  },

  loadRecords() {
    this.setData({
      isLoading: true,
      page: 0
    });

    try {
      const allRecords = wx.getStorageSync('measurement_records') || [];
      const records = allRecords.slice(0, this.data.pageSize);

      this.setData({
        records: records,
        hasMore: allRecords.length > this.data.pageSize,
        isLoading: false
      });
    } catch (e) {
      console.error('加载记录失败:', e);
      this.setData({
        isLoading: false
      });
      wx.showToast({
        title: '加载失败',
        icon: 'none'
      });
    }
  },

  loadMoreRecords() {
    if (this.data.isLoading || !this.data.hasMore) return;

    this.setData({
      isLoading: true
    });

    try {
      const allRecords = wx.getStorageSync('measurement_records') || [];
      const nextPage = this.data.page + 1;
      const startIndex = nextPage * this.data.pageSize;
      const endIndex = startIndex + this.data.pageSize;
      const moreRecords = allRecords.slice(startIndex, endIndex);

      this.setData({
        records: [...this.data.records, ...moreRecords],
        page: nextPage,
        hasMore: endIndex < allRecords.length,
        isLoading: false
      });
    } catch (e) {
      console.error('加载更多失败:', e);
      this.setData({
        isLoading: false
      });
    }
  },

  deleteRecord(e) {
    const id = e.currentTarget.dataset.id;
    
    wx.showModal({
      title: '删除记录',
      content: '确定要删除这条记录吗？',
      success: (res) => {
        if (res.confirm) {
          try {
            let records = wx.getStorageSync('measurement_records') || [];
            records = records.filter(r => r.id !== id);
            wx.setStorageSync('measurement_records', records);
            
            // 重新加载数据
            this.loadRecords();
            
            wx.showToast({
              title: '已删除',
              icon: 'success'
            });
          } catch (e) {
            console.error('删除失败:', e);
            wx.showToast({
              title: '删除失败',
              icon: 'none'
            });
          }
        }
      }
    });
  },

  deleteAllRecords() {
    wx.showModal({
      title: '删除所有记录',
      content: '确定要删除所有记录吗？此操作无法撤销。',
      success: (res) => {
        if (res.confirm) {
          try {
            wx.removeStorageSync('measurement_records');
            this.setData({
              records: [],
              hasMore: false
            });
            
            wx.showToast({
              title: '已全部删除',
              icon: 'success'
            });
          } catch (e) {
            console.error('删除失败:', e);
            wx.showToast({
              title: '删除失败',
              icon: 'none'
            });
          }
        }
      }
    });
  },

  formatDate(timestamp) {
    const date = new Date(timestamp);
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    const seconds = String(date.getSeconds()).padStart(2, '0');
    return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
  },

  formatDuration(seconds) {
    if (seconds < 60) {
      return `${seconds}秒`;
    } else if (seconds < 3600) {
      const minutes = Math.floor(seconds / 60);
      const secs = seconds % 60;
      return `${minutes}分${secs}秒`;
    } else {
      const hours = Math.floor(seconds / 3600);
      const minutes = Math.floor((seconds % 3600) / 60);
      return `${hours}小时${minutes}分`;
    }
  },

  getColorForDb(db) {
    if (db < 40) return '#4CAF50'; // 绿色
    if (db < 70) return '#FF9800'; // 橙色
    if (db < 90) return '#FF5722'; // 深橙色
    return '#F44336'; // 红色
  }
});
