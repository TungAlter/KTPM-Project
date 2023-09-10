// Lấy tham chiếu đến nút button và board-history
const btnShowHistory = document.querySelector('.btn-showHistory');
const boardHistory = document.querySelector('.board-history');
const iconExit = document.querySelector('.icon-exit');
const AuthToken = localStorage.getItem('AuthToken').slice(1, -1);

// Biến cục bộ để lưu dữ liệu địa điểm
let locationData = null;

// Hàm để tải dữ liệu địa điểm
async function fetchLocationData() {
    try {
        const response = await fetch('https://raw.githubusercontent.com/kenzouno1/DiaGioiHanhChinhVN/master/data.json', {
            method: 'GET',
            headers: {
                'Accept': 'application/json',
            },
        });

        if (!response.ok) {
            throw new Error('Failed to fetch location data from API');
        }

        locationData = await response.json(); // Lưu dữ liệu địa điểm vào biến locationData
    } catch (error) {
        console.error('Error fetching location data:', error);
        locationData = null;
    }
}

// Gọi hàm fetchLocationData để tải dữ liệu địa điểm khi trang web được tải
fetchLocationData();

//lấy api lịch sử
async function fetchBookingData() {
    try {
        const response = await fetch('http://localhost:5236/api/Booking/recent', {
            method: 'GET',
            headers: {
                'Accept': 'application/json', // Đảm bảo yêu cầu API trả về dữ liệu JSON
            },
        });

        if (!response.ok) {
            throw new Error('Failed to fetch data from API');
        }

        const data = await response.json(); // Chuyển đổi dữ liệu JSON thành đối tượng JavaScript
        return data;
    } catch (error) {
        console.error('Error fetching data:', error);
        return null;
    }
}


// console.log("token lấy được ở S1: " + AuthToken);

// Thêm sự kiện "click" cho nút button
btnShowHistory.addEventListener('click', async () => {
    // Lấy dữ liệu từ API
    const bookingData = await fetchBookingData();

    console.log(bookingData);

    if (bookingData) {
        // Hiển thị board-history khi nút được nhấp
        boardHistory.style.display = 'block';

        // Xóa dữ liệu cũ trong bảng lịch sử (nếu có)
        const listActivity = document.querySelector('.list-activity');
        listActivity.innerHTML = '';

        // Thêm dữ liệu mới từ API vào bảng lịch sử
        bookingData.forEach((booking) => {
            const cardActivity = document.createElement('div');
            cardActivity.className = 'card-acivity';
            const desAddr = booking.desAddress.split(",").slice(-2);
            console.log(desAddr);
            const srcAddr = booking.srcAddress.split(",").slice(-2);
            console.log(srcAddr);
            const addr = desAddr + "-" + srcAddr;
            const dateParts = booking.dateBooking.split("T")[0].split("-");
            const time = `${dateParts[2]}-${dateParts[1]}-${dateParts[0]}`;



            cardActivity.innerHTML = `
            <div class="card-logo">
                <i class="bi bi-taxi-front-fill"></i>
            </div>
            <div class="card-desc">
                <p class="title-name">${booking.fullName}</p>
                <p class="des-phone">${booking.phoneNumber}</p>
                <p class="des-address">${addr}</p>
            </div>
            <div class="card-meta">
                <a>${time}</a>
            </div>
        `;
            cardActivity.addEventListener("click", () => {
                console.log("click card");
                showPopup(booking);
            })

            listActivity.appendChild(cardActivity);

            // Thêm đường phân cách sau mỗi sự kiện
            const hrDivide = document.createElement('hr');
            hrDivide.className = 'board-menu-header-divide';
            listActivity.appendChild(hrDivide);
        });
    }
});

// Thêm sự kiện "click" cho nút icon-exit
iconExit.addEventListener('click', () => {
    // Đóng board-history khi nút icon-exit được nhấp
    boardHistory.style.display = 'none';
});


document.addEventListener("DOMContentLoaded", function () {
    const fullnameInput = document.getElementById("fullnameInput");
    const emailInput = document.getElementById("emailInput");
    const phonenumberInput = document.getElementById("phonenumberInput");
    const addressInfor = document.getElementById("addressInfor");
    const province = document.getElementById("province");
    const district = document.getElementById("district");
    const ward = document.getElementById("ward");
    const addressInfor_to = document.getElementById("addressInfor_to");
    const province_to = document.getElementById("province_to");
    const district_to = document.getElementById("district_to");
    const ward_to = document.getElementById("ward_to");
    const paymentConfirmBtn = document.getElementById("payment-confirm");

    paymentConfirmBtn.addEventListener("click", function (event) {
        if (!validateInput(fullnameInput.value)) {
            event.preventDefault();
            alert("Vui lòng nhập họ và tên!");
            fullnameInput.focus();
        } else if (!validateEmail(emailInput.value)) {
            event.preventDefault();
            alert("Vui lòng nhập email hợp lệ!");
            emailInput.focus();
        } else if (!validatePhoneNumber(phonenumberInput.value)) {
            event.preventDefault();
            alert("Vui lòng nhập số điện thoại hợp lệ (9-10 số)!");
            phonenumberInput.focus();
        } else if (!validateInput(addressInfor.value)) {
            event.preventDefault();
            alert("Vui lòng nhập địa chỉ đón!");
            addressInfor.focus();
        } else if (province.value === "") {
            event.preventDefault();
            alert("Vui lòng chọn tỉnh/thành phố!");
            province.focus();
        }
        // ... check other fields ...
        if (!validateInput(addressInfor_to.value)) {
            event.preventDefault();
            alert("Vui lòng nhập địa chỉ muốn đến!");
            addressInfor_to.focus();
        } else if (province_to.value === "") {
            event.preventDefault();
            alert("Vui lòng chọn tỉnh/thành phố muốn đến!");
            province_to.focus();
        } else if (district_to.value === "") {
            event.preventDefault();
            alert("Vui lòng chọn quận/huyện muốn đến!");
            district_to.focus();
        } else if (ward_to.value === "") {
            event.preventDefault();
            alert("Vui lòng chọn phường muốn đến!");
            ward_to.focus();
        }
    });
});


function validateInput(value) {
    return value.trim() !== "";
}

function validateEmail(email) {
    const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/u;
    return emailPattern.test(email);
}

function validatePhoneNumber(phoneNumber) {
    var phoneNumberPattern = /^\d{9,10}$/;
    return phoneNumberPattern.test(phoneNumber);
}

const apiUrl = "http://localhost:5236/api/Booking";


const headers = {
    'accept': 'text/plain',
    'Authorization': `Bearer ${AuthToken}`,
    'Content-Type': 'application/json'
};

console.log(headers);


async function validateAndSendData() {

    // const locationData = await response.json(); // Lấy dữ liệu địa điểm

    // Get input values
    const fullname = document.getElementById("fullnameInput").value;
    const email = document.getElementById("emailInput").value;
    const phoneNumber = document.getElementById("phonenumberInput").value;

    // Lấy giá trị của các ID cho addressFrom
    const selectedProvinceId = document.getElementById("province").value;
    const selectedDistrictId = document.getElementById("district").value;
    const selectedWardId = document.getElementById("ward").value;

    // Lấy giá trị của các ID cho addressTo
    const selectedProvinceIdTo = document.getElementById("province_to").value;
    const selectedDistrictIdTo = document.getElementById("district_to").value;
    const selectedWardIdTo = document.getElementById("ward_to").value;

    // Ánh xạ mã ID thành tên thực tế cho addressFrom
    const selectedProvince = locationData.find(item => item.Id === selectedProvinceId);
    const selectedDistrict = selectedProvince.Districts.find(item => item.Id === selectedDistrictId);
    const selectedWard = selectedDistrict.Wards.find(item => item.Id === selectedWardId);

    // Ánh xạ mã ID thành tên thực tế cho addressTo
    const selectedProvinceTo = locationData.find(item => item.Id === selectedProvinceIdTo);
    const selectedDistrictTo = selectedProvinceTo.Districts.find(item => item.Id === selectedDistrictIdTo);
    const selectedWardTo = selectedDistrictTo.Wards.find(item => item.Id === selectedWardIdTo);


    // Lấy tên thực tế từ các địa điểm đã ánh xạ cho addressFrom
    const provinceName = selectedProvince ? selectedProvince.Name : "";
    const districtName = selectedDistrict ? selectedDistrict.Name : "";
    const wardName = selectedWard ? selectedWard.Name : "";

    // Lấy tên thực tế từ các địa điểm đã ánh xạ cho addressTo
    const provinceNameTo = selectedProvinceTo ? selectedProvinceTo.Name : "";
    const districtNameTo = selectedDistrictTo ? selectedDistrictTo.Name : "";
    const wardNameTo = selectedWardTo ? selectedWardTo.Name : "";


    const addressFrom = {
        address: document.getElementById("addressInfor").value,
        province: provinceName,
        district: districtName,
        ward: wardName
    };
    const addressTo = {
        address: document.getElementById("addressInfor_to").value,
        province: provinceNameTo,
        district: districtNameTo,
        ward: wardNameTo
    };

    // Validate email and phone number
    if (!validateEmail(email)) {
        alert("Invalid email format");
        return;
    }
    if (!validatePhoneNumber(phoneNumber)) {
        alert("Invalid phone number format");
        return;
    }

    // Create an object with all data
    const dataToSend = {
        fullname: fullname,
        email: email,
        phone: phoneNumber,
        addrFrom: addressFrom,
        addrTo: addressTo
    };

    console.log(dataToSend);

    // Send data to API using fetch
    const apiUrl = "http://localhost:5236/api/Booking"; // Địa chỉ API cần gửi dữ liệu
    const headers = {
        'accept': 'text/plain',
        'Authorization': `Bearer ${AuthToken}`,
        'Content-Type': 'application/json'
    };

    try {
        const response = await fetch(apiUrl, {
            method: 'POST',
            headers: headers,
            body: JSON.stringify(dataToSend)
        });

        if (response.ok) {
            alert("successful");
            // Thực hiện các hành động khác nếu cần
        } else {
            alert("Please try again later.");
        }
    } catch (error) {
        console.error("An error occurred:", error);
    }
}


// Add event listener to the confirmation button
const confirmButton = document.getElementById("payment-confirm");
confirmButton.addEventListener("click", validateAndSendData);

// Get the history card elements
const historyCards = document.querySelectorAll(".card-acivity");

// Function to show popup with detailed information
function showPopup(cardActivity) {
    const popup = document.createElement("div");
    popup.classList.add("popup");

    const popupContent = document.createElement("div");
    popupContent.classList.add("popup-content");


    popupContent.innerHTML = `
        <h2>Thông tin chi tiết</h2>
        <p>Khách hàng: ${cardActivity.fullName}</p>
        <p>Email: ${cardActivity.email}</p>
        <p>Số điện thoại: ${cardActivity.phoneNumber}</p>
        <p>From: ${cardActivity.desAddress}</p>
        <p>To: ${cardActivity.srcAddress}</p>
        <button id="closePopup";">Close</button>
    `;

    popup.appendChild(popupContent);
    document.body.appendChild(popup);

    // Close the popup when the close button is clicked
    const closePopupButton = popup.querySelector("#closePopup");
    closePopupButton.addEventListener("click", () => {
        document.body.removeChild(popup);
    });
}

// Add click event listener to history cards
historyCards.forEach(card => {
    card.addEventListener("click", () => {
        console.log("click card")
        showPopup(card);
    });
});

