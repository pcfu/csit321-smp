$(document).on('turbolinks:load', function () {
    
 
    new Chart(document.getElementById("line-chart"), {
        type: 'line',
        data: {
            labels: ["2 Weeks", "1 Month", "3 Months", "12 Months"],
            datasets: [{ 
                data: [0,5,10,20,30],
                label: "Max",
                borderColor: "#61f29d",
                backgroundColor: "#61f29d",
                fill: true
            }, { 
                data: [0,0,0,-5,-10],
                label: "Expected",
                borderColor: "#8e5ea2",
                backgroundColor: "#8e5ea2",
                fill: true
            }, { 
                data: [0,-5,-10,-15,-25],
                label: "Min",
                borderColor: "#f26370",
                backgroundColor: "#f26370",
                fill: true,
            }, 
            ]
        },
        options: {
            title: {
            display: true,
            text: 'Expected Returns Prediction'
            }
        }
        });
    });