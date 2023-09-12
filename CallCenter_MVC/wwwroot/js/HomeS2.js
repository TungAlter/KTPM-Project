var map = null;
var route;
var startMarker;  
var endMarker;
var apiUrl = "YOUR_API_HERE"

const headers = {
    'accept': 'text/plain',
    'Content-Type': 'application/json'
};

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
function getRoute(bookingId, startAddress, endAddress) {
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
                        console.log(data);
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
                        
                        document.getElementById(`srclong-${bookingId}`).value = startCoords.lon;
                        document.getElementById(`srclat-${bookingId}`).value = startCoords.lat;
                        document.getElementById(`deslong-${bookingId}`).value = endCoords.lon;
                        document.getElementById(`deslat-${bookingId}`).value = endCoords.lat;
                        document.getElementById(`distance-${bookingId}`).value = routeDistance;
                        
                        enableBTNs(bookingId);
                        showModalDialog(bookingId, startAddress, endAddress)
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
function showModalDialog(bookingId, startaddress, endaddress){

    var detailBtn = document.getElementById(`detail-${bookingId}`)
    if (detailBtn.classList.contains('disable')) {
        var modal = document.getElementById('myModal');
        modal.style.display = 'hidden';
    } else {
        var idBooking = bookingId;
        var Customer = document.getElementById(`name-${bookingId}`).value;
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
}
function closeModal() {
    var modal = document.getElementById('myModal');
    modal.style.display = 'none';
}

// Xử lý enable button
function enableBTNs (bookingId) {
    var detailButton = document.getElementById(`detail-${bookingId}`);
    var sendButton = document.getElementById(`send-${bookingId}`);
    detailButton.classList.remove("disable");
    sendButton.classList.remove("disable");
}


// Xử lý gửi dữ liệu cập nhật
const updateBooking = {
    Id: -1,
    FullName: "",
    SrcAddress: null,
    SrcLon: -1,
    SrcLat: -1,
    DesAddress: null,
    DesLon: -1,
    DesLat: -1,
    Distance: 0
};
async function sendBooking(bookingId) {
    var sendBtn = document.getElementById(`send-${bookingId}`)
    if (sendBtn.classList.contains("disable")) {
        console.log("disable");
        return
    } else {
        var name = document.getElementById(`name-${bookingId}`).value;
        var startLat = document.getElementById(`srclat-${bookingId}`).value;
        var startLon = document.getElementById(`srclong-${bookingId}`).value;
        var endLat = document.getElementById(`deslat-${bookingId}`).value;
        var endLon = document.getElementById(`deslong-${bookingId}`).value;
        var routeDistance = document.getElementById(`distance-${bookingId}`).value;
        updateBooking.Id = bookingId;
        updateBooking.FullName = name;
        updateBooking.SrcLon = startLon;
        updateBooking.SrcLat = startLat;
        updateBooking.DesLon = endLon;
        updateBooking.DesLat = endLat;
        var urlUpdateBooking = `http://localhost:5236/api/Booking/location?id=${bookingId}&srcLong=${startLon}&srcLat=${startLat}&desLong=${endLon}&desLat=${endLat}&Distance=${routeDistance}`;
        console.log(urlUpdateBooking);
        try {
            const response = await fetch(urlUpdateBooking, {
                method: "PUT",
                headers: {
                    'accept': 'text/plain',
                },
                body: JSON.stringify(updateBooking),
            });
            console.log(response);
            console.log("Thành công");
        } catch (error) {
            console.error("An error occurred:", error);
        }

    }
}

// Xử lý xóa
function deleteBooking(bookingId) {
    if (confirm('Bạn có chắc chắn muốn xóa bản ghi này không?')) {
        // Sử dụng AJAX hoặc Fetch để gửi yêu cầu Xóa đến Action Delete trong Controller
        console.log(bookingId);
        fetch(`/HomeS2/Delete/${bookingId}`, {
            method: 'DELETE'
        })
        .then(response => {
            if (response.status === 200) {
                // Xóa thành công, sau đó chuyển hướng lại trang Index
                window.location.href = '/HomeS2/Index';
            } else {
                // Xóa không thành công, xử lý lỗi tại đây (nếu cần)
            }
        })
        .catch(error => {
            console.error("Lỗi khi xóa:", error);
            // Xử lý lỗi tại đây (nếu cần)
        });
    }
}

function longPolling() {
    setTimeout(function() {
        fetch('http://localhost:5236/api/Booking/new') // Replace with the correct URL for your Long-Polling action
            .then(response => {
                if (response.status === 200) {
                    // New data is available, handle it here
                    console.log("New data received");
                    console.log(response);
                    // Perform any necessary actions to update the UI or fetch data.
                    response.json().then(function(newData) {
                        console.log("New data received", newData);
                        //window.location.href = '/HomeS2/Index';
                        // Xử lý dữ liệu JSON và cập nhật giao diện
                        const bookingList = document.getElementById('booking-list');
                        bookingList.innerHTML = '';
                        newData.forEach(booking => {
                            const existingCard = document.getElementById(`card-${booking.idBooking}`);
                            if (!existingCard) {
                                // Nếu thẻ không tồn tại, tạo và thêm vào booking-list
                                const bookingCard = createBookingCard(booking);
                                bookingList.appendChild(bookingCard);
                            }
                        });
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

function createBookingCard(booking) {
    const cardHTML = `
        <div class="unapproved-card" id="card-${booking.IdBooking}">
            <div class="card-content" id="card-content" onclick="getRoute('${booking.IdBooking}', '@booking.SrcAddress', '@booking.DesAddress')">
                <div><span class="card-title">STT: </span>${booking.IdBooking}</div>
                <input type="hidden" id="id-${booking.IdBooking}" value="${booking.IdBooking}">

                <div><span class="card-title" type="hidden">Khách: </span>@booking.Customer</div>
                <input type="hidden" id="name-${booking.IdBooking}" value='${booking.Customer}'>

                <div><span class="card-title">Địa điểm đi: </span>@booking.SrcAddress</div>
                <input type="hidden" id="srcaddress-${booking.IdBooking}" value="${booking.SrcAddress}">
                <input type="hidden" id="srclong-${booking.IdBooking}" value="${booking.SrcLong}">
                <input type="hidden" id="srclat-${booking.IdBooking}" value="${booking.SrcLat}">

                <div><span class="card-title">Địa điểm đến: </span>@booking.DesAddress</div>
                <input type="hidden" id="desaddress-${booking.IdBooking}" value="${booking.DesAddress}">
                <input type="hidden" id="deslong-${booking.IdBooking}" value="${booking.DesLong}">
                <input type="hidden" id="deslat-${booking.IdBooking}" value="${booking.DesLat}">

                <input type=" " id="distance-${booking.IdBooking}" value="${booking.Distance}">
            </div>
            <div class="btn-area">
                @if (booking.Distance == 0) {
                    <span class="btn1 disable" id="detail-${booking.IdBooking}" onclick="showModalDialog('${booking.IdBooking}', '@booking.SrcAddress', '@booking.DesAddress')">Detail</span>
                    <span class="btn2 disable" id="send-${booking.IdBooking}" onclick="sendBooking('${booking.IdBooking}')">Send</span>
                    <span class="btn3" onclick="deleteBooking('${booking.IdBooking}')">Discard</span>
                } else {
                    <span class="btn1" id="detail-${booking.IdBooking}" onclick="showModalDialog('${booking.IdBooking}', '@booking.SrcAddress', '@booking.DesAddress')">Detail</span>
                    <span class="btn2" id="send-${booking.IdBooking}" onclick="sendBooking('${booking.IdBooking}')">Send</span>
                    <span class="btn3" onclick="deleteBooking('${booking.IdBooking}')">Discard</span>
                }
                
            </div>
        </div>
    `;
    const card = document.createElement('div');
    card.innerHTML = cardHTML;

    return card.firstChild;// Make sure to return the card element
}


// Xử lý hiện map sử dụng LeafL et
window.onload = function() {    
    map = L.map('map').setView([10.7743, 106.6669], 10);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map);
    longPolling();
}

function sendWithModal(){
    var modal = document.getElementById('myModal');
    let idBooking = document.getElementById(`modal-bookingId`).textContent;
    console.log("id", idBooking);
    sendBooking(idBooking);
}





