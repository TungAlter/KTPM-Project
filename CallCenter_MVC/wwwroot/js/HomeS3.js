var map = null;
var route;
var startMarker;
var endMarker;
var apiUrl = "YOUR_API_HERE"

const updateBooking = {
    Id: -1,
    FullName: "",
    SrcAddress: null,
    SrcLon: -1,
    SrcLat: -1,
    DesAddress: null,
    DesLon: -1,
    DesLat: -1,
    Distance: 0,
    Note: "",
    Total: 0
};

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
    var Driver = document.getElementById(`drivername-${bookingId}`).value;
    var startAddress = document.getElementById(`srcaddress-${bookingId}`).value;
    var startLat = document.getElementById(`srclat-${bookingId}`).value;
    var startLon = document.getElementById(`srclong-${bookingId}`).value;
    var endAddress = document.getElementById(`desaddress-${bookingId}`).value;
    var endLat = document.getElementById(`deslat-${bookingId}`).value;
    var endLon = document.getElementById(`deslong-${bookingId}`).value;
    var routeDistance = document.getElementById(`distance-${bookingId}`).value;
    var total = document.getElementById(`total-${bookingId}`).value;

    document.getElementById('modal-bookingId').textContent = idBooking;
    document.getElementById('modal-customerName').textContent = Customer;
    document.getElementById('modal-driverName').textContent = Driver;
    document.getElementById('modal-startAddress').textContent = startAddress;
    document.getElementById('modal-startLat').textContent = startLat;
    document.getElementById('modal-startLon').textContent = startLon;
    document.getElementById('modal-endAddress').textContent = endAddress;
    document.getElementById('modal-endLat').textContent = endLat;
    document.getElementById('modal-endLon').textContent = endLon;
    document.getElementById('modal-routeDistance').textContent = routeDistance;
    document.getElementById('modal-Total').textContent = total;

    var modal = document.getElementById('myModal');
    modal.style.display = 'block';

}
function closeModal() {
    var modal = document.getElementById('myModal');
    modal.style.display = 'none';
}

function longPolling() {
    setTimeout(function() {
        fetch('http://localhost:5236/api/Booking/received') // Replace with the correct URL for your Long-Polling action
            .then(response => {
                if (response.status === 200) {
                    // New data is available, handle it here
                    console.log("New data received");
                    console.log(response);
                    // Perform any necessary actions to update the UI or fetch data.
                    response.json().then(function(newData) {
                        console.log("New data received", newData);
                        //window.location.href = '/HomeS3/Index';
                        // Xử lý dữ liệu JSON và cập nhật giao diện
                        const bookingList = document.getElementById('booking-list');
                        newData.forEach(booking => {
                            const existingCard = document.getElementById(`card-${booking.id}`);
                            if (!existingCard) {
                                // Nếu thẻ không tồn tại, tạo và thêm vào booking-list
                                const bookingCard = createBookingCard(booking);
                                console.log(bookingCard);
                                bookingList.appendChild(bookingCard);
                            }
                        });
                        console.log(bookingList);
                    });
                }
                // After handling the response, initiate Long-Polling again.
                longPolling();
            })
            .catch(error => {
                console.error("Error during Long-Polling:", error);
                // Handle errors, and then retry Long-Polling.
                longPolling();
            });
    }, 10000); 
}

window.onload = function () {
    map = L.map('map').setView([10.7743, 106.6669], 10);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map);
    longPolling();
}

function createBookingCard(booking) {
    console.log(booking);
    const cardHTML = `
            <div class="card-content" id="card-content" onclick="showRoute(${booking.id})">
                <div><span class="card-title">STT: </span>${booking.id}</div>
                <input type="hidden" id="id-${booking.id}" value="${booking.id}">

                <div><span class="card-title" type="hidden">Khách: </span>${booking.customerName}</div>
                <input type="hidden" id="customername-${booking.id}" value='${booking.customerName}'>

                <div><span class="card-title" type="hidden">Tài xế: </span>${booking.driverName}</div>
                <input type="hidden" id="drivername-${booking.id}" value='${booking.driverName}'>

                <div><span class="card-title">Địa điểm đi: </span>${booking.srcAddress}</div>
                <input type="hidden" id="srcaddress-${booking.id}" value="${booking.srcAddress}">
                <input type="hidden" id="srclong-${booking.id}" value="${booking.srcLong}">
                <input type="hidden" id="srclat-${booking.id}" value="${booking.srcLat}">

                <div><span class="card-title">Địa điểm đến: </span>${booking.desAddress}</div>
                <input type="hidden" id="desaddress-${booking.id}" value="${booking.desAddresso}">
                <input type="hidden" id="deslong-${booking.id}" value="${booking.desLong}">
                <input type="hidden" id="deslat-${booking.id}" value="${booking.desLat}">

                <input type="hidden" id="distance-${booking.id}" value="${booking.distance}">
            </div>
            <div class="btn-area">
                <span class="btn1" id="detail-${booking.id}" onclick="showModalDialog(${booking.id}, '${booking.srcAddress}', '${booking.desAddress}')">Detail</span>
            </div>
    `;
    const card = document.createElement('div');
    card.classList.add('unapproved-card');
    card.id = `card-${booking.id}`;
    card.innerHTML = cardHTML;
    console.log("Thêm thẻ thành công")
    return card// Make sure to return the card element
}