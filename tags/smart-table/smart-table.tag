<smart-table>
  <input type="text" id="global-search" onkeyup = "{ search }"/>
  <table>
    <thead>
      <tr>
        <th each={ header, i in headers } onclick="{ colSort }" class = "{ asc: parent.sortState[i].order === 'asc' }">{ header }</th>
      </tr>
    </thead>
    <tbody>
      <tr each="{row in filteredData }">
        <td each={ key, value in row }> { value }</td>
      </tr>
    </tbody>
  </table>

  <script>
    var self = this;
    this.data = opts.data;
    console.log(this.data);
    this.headers = Object.keys(this.data[0]);

    this.options = {
      columnDefs: [{
        target: 0,
        sortable: true,
        type: 'text'
      }]
    };

    this.sortState = [];

    this.filteredData = this.data;

    this.headers.forEach(function() {
      this.sortState.push({order: 'asc'});
    }, this);


    _textSort(data, col, colHeaderName) {
      return function compare(curr, next) {
        if(col.order === 'asc') {
          //asc: true
          return ((curr[colHeaderName] < next[colHeaderName] ) ? -1 : (curr[colHeaderName] > next[colHeaderName] ) ? 1: 0);
        } else {
          //dsc
          return ((curr[colHeaderName] > next[colHeaderName] ) ? -1 : (curr[colHeaderName] < next[colHeaderName] ) ? 1: 0);
        }
      }
    }

    _sort(data, type, col, colIndex) {

      var colHeaderName = this.headers[colIndex];
      var compare;

      if(type === 'text') {
        compare = this._textSort(data, col, colHeaderName);
      }
      data.sort(compare);
    }


    colSort(e) {
      console.log(e);
      var index = e.target.cellIndex;
      var col = this.sortState[index];
      col.order = (col.order === 'asc' ? 'dsc' : 'asc');
      //reset other columns sort status to false
      // this.sortState.forEach(function(col, i) {
      //   if(index !== i) {
      //     col.asc = false;
      //   }
      // });
      console.log(this.sortState);
      this._sort(this.data, 'text', col, index );
    }

    search(e) {
      var input = e.target;
      this.searchText = input.value.toLowerCase();
      // console.log(this.searchText);
      console.log(this._searchData(this.searchText));
      this.filteredData = this._searchData(this.searchText);
    }

    _searchData() {
      var searchText = this.searchText;
      if(searchText.length <= 1 ) return this.data;
      return this.data.filter(function(row) {
        var result = Object.keys(row).filter(function(key) {
          // console.log(row[key]);
          // console.log(row[key].toLowerCase().includes(searchText));
          return row[key].toLowerCase().includes(searchText);
        }, this);
        // console.log(result);
        return (result.length > 0);
      })
    }
    // setTimeout(function() {
    //   self._sort(self.data, 'text', 'asc', 0);
    //   self.update();
    //   console.log('Timeout');
    // }, 3000);

  </script>
</smart-table>