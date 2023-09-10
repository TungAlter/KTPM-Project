var map = null;
var route;
var startMarker;  
var endMarker;
var apiUrl = "YOUR_API_HERE"

window.onload = function() {    
    map = L.map('map').setView([10.7743, 106.6669], 10);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map);
    //longPolling();
}