var map = null;
var route;
var startMarker;
var endMarker;
var apiUrl = "YOUR_API_HERE"

function showRoute(bookingId) {
    if (startMarker || endMarker || route) {
        map.removeLayer(startMarker);
        map.removeLayer(endMarker);
        map.removeLayer(route);
    }
    var startAddress = document.getElementById(`srcaddress-${bookingId}`).value;
    var startLat = document.getElementById(`srclat-${bookingId}`).value;
    var startLon = document.getElementById(`srclong-${bookingId}`).value;
    var endAddress = document.getElementById(`desaddress-${bookingId}`).value;
    var endLat = document.getElementById(`deslat-${bookingId}`).value;
    var endLon = document.getElementById(`deslong-${bookingId}`).value;
    var routeDistance = document.getElementById(`distance-${bookingId}`).value;
    Promise.all([{ startLat, startLon }, { endLat, endLon }])
        .then(coords => {
            console.log(coords[0]);
            var startCoords = coords[0];
            var endCoords = coords[1];
            console.log(startCoords.startLat, ", ", startCoords.startLon);
            if (startCoords && endCoords) {
                var routingUrl = `https://api.openrouteservice.org/v2/directions/driving-car?api_key=5b3ce3597851110001cf62482b5d590182b843fdbc48437f5db43cf9&start=${startCoords.startLon},${startCoords.startLat}&end=${endCoords.endLon},${endCoords.endLat}`;
                return fetch(routingUrl)
                    .then(response => response.json())
                    .then(data => {
                        var routeCoordinates = data.features[0].geometry.coordinates;

                        // Tạo marker cho địa điểm xuất phát và đích
                        startMarker = L.marker([startCoords.startLat, startCoords.startLon]).addTo(map)
                            .bindPopup(startAddress)
                            .openPopup();
                        endMarker = L.marker([endCoords.endLat, endCoords.endLon]).addTo(map)
                            .bindPopup(endAddress)
                            .openPopup();

                        var routeLatLngs = routeCoordinates.map(coord => [coord[1], coord[0]]);
                        route = L.polyline(routeLatLngs, { color: 'blue' }).addTo(map);
                        map.fitBounds(route.getBounds());

                        showModalDialog(bookingId);

                        console.log("Khoảng cách tuyến đường:", routeDistance, "mét");
                    })
                    .catch(error => {
                        console.log("Lỗi khi lấy tuyến đường:", error);
                    });
            }
        })
        .catch(error => {
            console.log("Lỗi khi lấy tọa độ:", error);
        });
}

function showModalDialog(bookingId, startaddress, endaddress) {
    var idBooking = bookingId;
    var Customer = document.getElementById(`customername-${bookingId}`).value;
    var startAddress = startaddress;
    var startLat = document.getElementById(`srclat-${bookingId}`).value;
    var startLon = document.getElementById(`srclong-${bookingId}`).value;
    var endAddress = endaddress;
    var endLat = document.getElementById(`deslat-${bookingId}`).value;
    var endLon = document.getElementById(`deslong-${bookingId}`).value;
    var routeDistance = document.getElementById(`distance-${bookingId}`).value;

    document.getElementById('modal-bookingId').textContent = idBooking;
    document.getElementById('modal-customerName').textContent = Customer;
    document.getElementById('modal-startAddress').textContent = startAddress;
    document.getElementById('modal-startLat').textContent = startLat;
    document.getElementById('modal-startLon').textContent = startLon;
    document.getElementById('modal-endAddress').textContent = endAddress;
    document.getElementById('modal-endLat').textContent = endLat;
    document.getElementById('modal-endLon').textContent = endLon;
    document.getElementById('modal-routeDistance').textContent = routeDistance;

    var modal = document.getElementById('myModal');
    modal.style.display = 'block';

}
function closeModal() {
    var modal = document.getElementById('myModal');
    modal.style.display = 'none';
}

window.onload = function () {
    map = L.map('map').setView([10.7743, 106.6669], 10);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map);
    //longPolling();
}