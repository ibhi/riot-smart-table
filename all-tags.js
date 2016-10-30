riot.tag2('my-tag', '<h3>Tag layout</h3> <inner-tag></inner-tag>', '', '', function(opts) {
});
riot.tag2('smart-table', '<input type="text" id="global-search" onkeyup="{search}"> <table> <thead> <tr> <th each="{header, i in headers}" onclick="{colSort}" class="{asc: parent.sortState[i].order === \'asc\'}">{options.columnDefs[i].title || header}</th> </tr> </thead> <tbody> <tr each="{row in filteredData}"> <td each="{key, value in row}"> {value}</td> </tr> </tbody> </table>', '', '', function(opts) {
    var self = this;
    this.data = opts.data;
    console.log(this.data);
    this.headers = Object.keys(this.data[0]);

    this.options = {
      globalSearch: true,
      columnDefs: [{
        title: 'First Name',
        sortable: true,
        type: 'text'
      }, {
        title: 'Last Name',
        sortable: true,
        type: 'text'
      }, {
        title: 'Age',
        sortable: true,
        type: 'text'
      }]
    };

    this.sortState = [];

    this.filteredData = this.data;

    this.headers.forEach(function() {
      this.sortState.push({order: 'asc'});
    }, this);

    this._textSort = function(data, col, colHeaderName) {
      return function compare(curr, next) {
        if(col.order === 'asc') {

          return ((curr[colHeaderName] < next[colHeaderName] ) ? -1 : (curr[colHeaderName] > next[colHeaderName] ) ? 1: 0);
        } else {

          return ((curr[colHeaderName] > next[colHeaderName] ) ? -1 : (curr[colHeaderName] < next[colHeaderName] ) ? 1: 0);
        }
      }
    }.bind(this)

    this._sort = function(data, type, col, colIndex) {

      var colHeaderName = this.headers[colIndex];
      var compare;

      if(type === 'text') {
        compare = this._textSort(data, col, colHeaderName);
      }
      data.sort(compare);
    }.bind(this)

    this.colSort = function(e) {
      console.log(e);
      var index = e.target.cellIndex;
      var col = this.sortState[index];
      col.order = (col.order === 'asc' ? 'dsc' : 'asc');

      console.log(this.sortState);
      this._sort(this.data, 'text', col, index );
    }.bind(this)

    this.search = function(e) {
      var input = e.target;
      this.searchText = input.value.toLowerCase();

      console.log(this._searchData(this.searchText));
      this.filteredData = this._searchData(this.searchText);
    }.bind(this)

    this._searchData = function() {
      var searchText = this.searchText;
      if(searchText.length <= 1 ) return this.data;
      return this.data.filter(function(row) {
        var result = Object.keys(row).filter(function(key) {

          return row[key].toLowerCase().includes(searchText);
        }, this);

        return (result.length > 0);
      })
    }.bind(this)

});