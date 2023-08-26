// Lấy tham chiếu đến nút button và board-history
const btnShowHistory = document.querySelector('.btn-showHistory');
const boardHistory = document.querySelector('.board-history');
const iconExit = document.querySelector('.icon-exit');

// Thêm sự kiện "click" cho nút button
btnShowHistory.addEventListener('click', () => {
    // Hiển thị board-history khi nút được nhấp
    boardHistory.style.display = 'block';
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
    

    function validateAndSendData() {
        // Get input values
        const fullname = document.getElementById("fullnameInput").value;
        const email = document.getElementById("emailInput").value;
        const phoneNumber = document.getElementById("phonenumberInput").value;
        const addressFrom = {
            address: document.getElementById("addressInfor").value,
            province: document.getElementById("province").value,
            district: document.getElementById("district").value,
            ward: document.getElementById("ward").value
        };
        const addressTo = {
            address: document.getElementById("addressInfor_to").value,
            province: document.getElementById("province_to").value,
            district: document.getElementById("district_to").value,
            ward: document.getElementById("ward_to").value
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
            phoneNumber: phoneNumber,
            addressFrom: addressFrom,
            addressTo: addressTo
        };

        console.log(dataToSend);
        
        // Send data to API using axios
        const apiUrl = "YOUR_API_URL_HERE";
        axios.post(apiUrl, dataToSend)
            .then(response => {
                // Handle success response here
                console.log("Data sent successfully", response.data);
            })
            .catch(error => {
                // Handle error here
                console.error("Error sending data", error);
                alert('complete save infomation but api not work')
            });
    }
    
    // Add event listener to the confirmation button
    const confirmButton = document.getElementById("payment-confirm");
    confirmButton.addEventListener("click", validateAndSendData);

    // Get the history card elements
const historyCards = document.querySelectorAll(".card-acivity");

// Function to show popup with detailed information
function showPopup(activity) {
    const popup = document.createElement("div");
    popup.classList.add("popup");
    
    const popupContent = document.createElement("div");
    popupContent.classList.add("popup-content");
    
    // Customize the content based on the selected activity
    // You can access the activity details using activity.querySelector(".card-desc").innerText, etc.
    // Example:
    // const activityDesc = activity.querySelector(".card-desc").innerText;
    // const popupText = document.createTextNode(activityDesc);
    // popupContent.appendChild(popupText);
    
    popupContent.innerHTML = `
        <h2>Thông tin chi tiết</h2>
        <p>${activity.querySelector(".card-desc").innerText}</p>
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
        showPopup(card);
    });
});

    