var table_data = [ { first_name : 'Rose',
                     last_name  : 'Tyler',
                     home       : 'Earth' },
                   { first_name : 'Zoe',
                     last_name  : 'Heriot',
                     home       : 'Space Station W3'},
                   { first_name : 'Jo',
                     last_name  : 'Grant',
                     home       : 'Earth'},
                   { first_name : 'Leela',
                     last_name  : null,
                     home       : 'Unspecified'},
                   { first_name : 'Romana',
                     last_name  : null,
                     home       : 'Gallifrey'},
                   { first_name : 'Clara',
                     last_name  : 'Oswald',
                     home       : 'Earth'},
                   { first_name : 'Adric',
                     last_name  : null,
                     home       : 'Alzarius'},
                   { first_name : 'Susan',
                     last_name  : 'Foreman',
                     home       : 'Gallifrey'} ];

// Function to generate table data.
function generateTable(data, section) {
    // Save area that was selected, and generate table skeleton
    var div = document.getElementById(section);
    var table = document.createElement('table');
    var tableHead = document.createElement('thead');
    var tableBody = document.createElement('tbody');

    // Set up style for generated table elements
    table.style.borderCollapse = 'collapse'
    table.style.borderSpacing = '0px';
    table.style.textAlign = 'center';
    table.style.margin = '0 auto';
    table.style.border = '1px solid #000';
    tableHead.style.backgroundColor = '#FFF';

    // Generate column names from data
    for (key in data[0]){
        var formatted_name = formatKey(key);
        var th = document.createElement('th');
        th.style.border = '1px solid #000';
        th.style.padding = '5px';
        th.appendChild(document.createTextNode(formatted_name));
        tableHead.appendChild(th);
    }
    // Table head complete, append to table
    table.appendChild(tableHead);
    
    // Generate rows (and cells) of data and set appropriate styling
    for (var i = 0; i < data.length; i++) {
        var row = document.createElement('tr');
        
        if (i % 2 === 0) {
            row.style.backgroundColor = '#DDD';
        } else {
            row.style.backgroundColor = '#FFF';
        }

        for (key in data[i]) {
            var td = row.insertCell();
            td.style.border = '1px solid black';
            td.style.padding = '5px';
            if (data[i][key] === null) {
                td.appendChild(document.createTextNode('(Not Provided)'));
            } else {
                td.appendChild(document.createTextNode(data[i][key]));
            }
        }

        // Row complete, append to table body
        tableBody.appendChild(row);
    }

    // Table body complete, append to table, and then append table to the selected div
    table.appendChild(tableBody);
    div.appendChild(table);
}

// Function to properly format column names since they're pulled straight from the data.
function formatKey(str) {
    var words = str.split('_');
    for (i=0; i<words.length; i++) {
        words[i] = words[i].charAt(0).toUpperCase() + words[i].slice(1);
    }

    return words.join(' ');
}

// Function that adds table to selected div (or removes it if it already exists)
function setArea() {
    if (this.querySelector('table') === null) {
        generateTable(table_data, this.id);
    } else {
        var table = this.querySelector('table');
        this.removeChild(table);
    }
}

// Set up event listeners for click on applicable divs
var area1 = document.getElementById('area1');
var area2 = document.getElementById('area2');
var area3 = document.getElementById('area3');
area1.addEventListener('click', setArea);
area2.addEventListener('click', setArea);
area3.addEventListener('click', setArea);