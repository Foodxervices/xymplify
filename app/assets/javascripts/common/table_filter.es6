const TableFilter = function(id) {
  let input, filter, table, tr, td, i, ii
  input = document.getElementById(id)
  table = document.getElementById(input.getAttribute("target"))
  tr = table.querySelectorAll("tbody tr")

  input.onkeyup = () => {
    filter = input.value.toUpperCase()

    for (i = 0; i < tr.length; i++) {
      let display = 'none'

      td = tr[i].querySelectorAll("td.filterable")

      for (ii = 0; ii < td.length; ii++) {
        if (td[ii].innerHTML.toUpperCase().indexOf(filter) > -1) {
          display = ''
          break
        }
      }

      tr[i].style.display = display
    }
  }
}