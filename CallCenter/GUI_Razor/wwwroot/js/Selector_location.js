
let citis = document.getElementById("province");
let districts = document.getElementById("district");
let wards = document.getElementById("ward");
//to
let citisTo = document.getElementById("province_to");
let districtsTo = document.getElementById("district_to");
let wardsTo = document.getElementById("ward_to");

let Parameter = {
    url: "https://raw.githubusercontent.com/kenzouno1/DiaGioiHanhChinhVN/master/data.json",
    method: "GET",
    responseType: "application/json",
};

let promise = axios(Parameter);
promise.then(function(result) {
    renderCity(result.data);
});

function renderCity(data) {
    for (const x of data) {
        citis.options[citis.options.length] = new Option(x.Name, x.Id);
        citisTo.options[citisTo.options.length] = new Option(x.Name, x.Id); // Add option for "province_to"
    }
    citis.onchange = function() {
        district.length = 1;
        ward.length = 1;
        if (this.value != "") {
            const result = data.filter(n => n.Id === this.value);

            for (const k of result[0].Districts) {
                districts.options[districts.options.length] = new Option(k.Name, k.Id);
            }
        }
    };
    districts.onchange = function() {
        ward.length = 1;
        const dataCity = data.filter((n) => n.Id === citis.value);
        if (this.value != "") {
            const dataWards = dataCity[0].Districts.filter(n => n.Id === this.value)[0].Wards;

            for (const w of dataWards) {
                wards.options[wards.options.length] = new Option(w.Name, w.Id);
            }
        }
    };

    // Add the following code for dropdown "province_to", "district_to", and "ward_to"
    citisTo.onchange = function() {
        districtsTo.length = 1;
        wardsTo.length = 1;
        if (this.value != "") {
            const result = data.filter(n => n.Id === this.value);

            for (const k of result[0].Districts) {
                districtsTo.options[districtsTo.options.length] = new Option(k.Name, k.Id);
            }
        }
    };
    districtsTo.onchange = function() {
        wardsTo.length = 1;
        const dataCity = data.filter((n) => n.Id === citisTo.value);
        if (this.value != "") {
            const dataWards = dataCity[0].Districts.filter(n => n.Id === this.value)[0].Wards;

            for (const w of dataWards) {
                wardsTo.options[wardsTo.options.length] = new Option(w.Name, w.Id);
            }
        }
    };
}
