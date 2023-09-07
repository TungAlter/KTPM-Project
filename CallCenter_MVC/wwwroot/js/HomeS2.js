var map = null;
var route;
var startMarker;  
var endMarker;
var startAt = "216/9 Dương Bá Trạc, phường 2, quận 8, TP.HCM";
var endAt = "Trường Đại học Khoa học Tự nhiên TP.HCM";

// Xử lý lấy tọa độ qua địa chỉ
function getCoordinates(address) {
    var nominatimUrl = `https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(address)}`;
    return fetch(nominatimUrl)
        .then(response => response.json())
        .then(data => {
            if (data.length > 0) {
                var lat = parseFloat(data[0].lat);
                var lon = parseFloat(data[0].lon);
                console.log("Address:", address)
                console.log("Latitude:", lat);
                console.log("Longitude:", lon);

                return { lat, lon };
            } else {
                console.log("Không thể lấy tọa độ từ địa chỉ.");
                return null;
            }
        })
        .catch(error => {
            console.log("Lỗi:", error);
        });
}

// Xử lý lấy đường đi
function getRoute(startAddress, endAddress, customerId) {
    if (startMarker || endMarker || route){
        map.removeLayer(startMarker);
        map.removeLayer(endMarker);
        map.removeLayer(route);
    }
    Promise.all([getCoordinates(startAddress), getCoordinates(endAddress)])
        .then(coords => {
            var startCoords = coords[0];
            var endCoords = coords[1];

            if (startCoords && endCoords) {
                var routingUrl = `https://api.openrouteservice.org/v2/directions/driving-car?api_key=5b3ce3597851110001cf62482b5d590182b843fdbc48437f5db43cf9&start=${startCoords.lon},${startCoords.lat}&end=${endCoords.lon},${endCoords.lat}`;

                return fetch(routingUrl)
                    .then(response => response.json())
                    .then(data => {
                        var routeCoordinates = data.features[0].geometry.coordinates;
                        var routeDistance = data.features[0].properties.segments[0].distance / 1000;

                        // Tạo marker cho địa điểm xuất phát và đích
                        startMarker = L.marker([startCoords.lat, startCoords.lon]).addTo(map)
                            .bindPopup(startAddress)
                            .openPopup();
                        endMarker = L.marker([endCoords.lat, endCoords.lon]).addTo(map)
                            .bindPopup(endAddress)
                            .openPopup();

                        var routeLatLngs = routeCoordinates.map(coord => [coord[1], coord[0]]);
                        route = L.polyline(routeLatLngs, { color: 'blue' }).addTo(map);
                        map.fitBounds(route.getBounds());
                        
                        console.log("Khoảng cách tuyến đường:", routeDistance, "mét");
                        
                        document.getElementById(`srclong-${customerId}`).value = startCoords.lon;
                        document.getElementById(`srclat-${customerId}`).value = startCoords.lat;
                        document.getElementById(`deslong-${customerId}`).value = endCoords.lon;
                        document.getElementById(`deslat-${customerId}`).value = endCoords.lat;
                        document.getElementById(`distance-${customerId}`).value = routeDistance;
                        
                        enableBTNs(customerId);
                        showModalDialog(customerId, startAddress, endAddress)
                        return allInfo = {
                            startAddress: startAddress,
                            endAddress: endAddress,
                            startCoords: startCoords,
                            endCoords: endCoords,   
                            routeDistance: distance
                        };
                        
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

// Xử lý hiện/ẩn Modal Dialog
function showModalDialog(customerId, startaddress, endaddress){

    var detailBtn = document.getElementById(`detail-${customerId}`)
    if (detailBtn.classList.contains('disable')) {
        var modal = document.getElementById('myModal');
        modal.style.display = 'hidden';
    } else {
        var idCustomer = customerId;
        var nameCustomer = document.getElementById(`name-${customerId}`).value;;
        var startAddress = startaddress;
        var startLat = document.getElementById(`srclat-${customerId}`).value;
        var startLon = document.getElementById(`srclong-${customerId}`).value;
        var endAddress = endaddress;
        var endLat = document.getElementById(`deslat-${customerId}`).value;
        var endLon = document.getElementById(`deslong-${customerId}`).value;
        var routeDistance = document.getElementById(`distance-${customerId}`).value;
    
        document.getElementById('modal-customerId').textContent = idCustomer;
        document.getElementById('modal-customerName').textContent = nameCustomer;
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
    // var btnArea = document.querySelector(".btn-area");
    // var detailBtn = btnArea.querySelector(".btn1");    
}
function closeModal() {
    var modal = document.getElementById('myModal');
    modal.style.display = 'none';
}


// Xử lý enable button
function enableBTNs (customerId) {
    var detailButton = document.getElementById(`detail-${customerId}`);
    var sendButton = document.getElementById(`send-${customerId}`);
    detailButton.classList.remove("disable");
    sendButton.classList.remove("disable");
}

// Xử lý hiện map sử dụng LeafLet
window.onload = function() {
    map = L.map('map').setView([10.7743, 106.6669], 10);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map);

    
}


// Xử lý hiện map sử dụng Google Map