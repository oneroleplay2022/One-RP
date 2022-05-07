let currentRequiredItem;

window.addEventListener('message', (event) => {
    let data = event.data;
    if (data.action == "show") {
        currentRequiredItem = null;
        $("#usb-container").fadeIn();
        $('#usb-choose').html("");
        for (const info in data.info) {
            let item = data.info[info];
            let items = `
            <div class="usb" data-info=${item.item} data-item=${item.itemName}>
                <img id="usb-img" src=nui://${item.itemImg}>
                <span style="white-space:nowrap; font-size: 1.2rem;" id="usb-text">${item.itemlabel}</span>
            </div>
            `
            $('#usb-choose').append(items);
        }
    } else if (data.action == "next") {
        $("#usb-container").fadeOut();
        $("#craftBtn").hide();
        $("#subtitle").text("Menu");
        $(".crafting-info").css("border-top", "2px solid transparent");
        $("#crafting-container").css("height", "420px");
        $('#crafting-option-container').html("");
        $("#crafting-container").show(500);
        $(".info-text1").text(data.resources.item1.label);
        $(".info-text2").text(data.resources.item2.label);
        $(".info-text3").text(data.resources.item3.label);
        $(".info-text4").text(data.resources.item4.label);
        $(".info-image1").attr("src", `nui://${data.resources.item1.image}`)
        $(".info-image2").attr("src", `nui://${data.resources.item2.image}`)
        $(".info-image3").attr("src", `nui://${data.resources.item3.image}`)
        $(".info-image4").attr("src", `nui://${data.resources.item4.image}`)
        $(".i").text("have:");
        $("#item1").text(data.invItems.item1);
        $("#item2").text(data.invItems.item2);
        $("#item3").text(data.invItems.item3);
        $("#item4").text(data.invItems.item4);
        currentRequiredItem = data.requiredItem;
        for (const info of data.weapons) {
            const resource = info.weaponResources;
            let html = `
            <div data-weaponprice=${info.price}  data-weaponhash=${info.weaponName} data-need1=${JSON.stringify(resource.item1)} data-need2=${JSON.stringify(resource.item2)} data-need3=${JSON.stringify(resource.item3)} data-need4=${JSON.stringify(resource.item4)} data-resources=${JSON.stringify(info.weaponResources)} data-label=${JSON.stringify(info.weaponLabel)} class="crafting-options border">
                <span id="crafting-options-text">${info.weaponLabel}</span>
            </div>
            `
            $('#crafting-option-container').append(html);
        }
    } else if (data.action == "have1") {
        $(".res1").css("border-top", "2px solid green");
    } else if (data.action == "have2") {
        $(".res2").css("border-top", "2px solid green");
    } else if (data.action == "have3") {
        $(".res3").css("border-top", "2px solid green");
    } else if (data.action == "have4") {
        $(".res4").css("border-top", "2px solid green");
    } else if (data.action == "donthave1") {
        $(".res1").css("border-top", "2px solid grey");
    } else if (data.action == "donthave2") {
        $(".res2").css("border-top", "2px solid grey");
    } else if (data.action == "donthave3") {
        $(".res3").css("border-top", "2px solid grey");
    } else if (data.action == "donthave4") {
        $(".res4").css("border-top", "2px solid grey");
    }
    if (data.action == "addBtn") {
        $("#crafting-container").css("height", "480px");
        setTimeout(() => {
            $("#craftBtn").fadeIn();
        }, 400);
    } else if (data.action == "removeBtn") {
        $("#craftBtn").fadeOut();
        setTimeout(() => {
            $("#crafting-container").css("height", "420px");
        }, 400);
    }
})

$("#usb-container").on("click", "#default-weapon", function () {
    let data = $(this).data("info");
    $("#usb-container").fadeOut();
    $.post("https://rn-crafting/choose", JSON.stringify({ data }));
})

$("#usb-container").on("click", ".usb", function () {
    let data = $(this).data("info");
    let item = $(this).data("item");
    $.post("https://rn-crafting/choose", JSON.stringify({ data, item }));
})

let currentWeapon;
let weaponRes1;
let weaponRes2;
let weaponRes3;
let weaponRes4;
let weaponPricee;

$("#crafting-container").on("click", ".crafting-options.border", function () {
    let weapon = $(this).data("label");
    let resources = $(this).data("resources");
    let weaponName1 = $(this).data("need1");
    let weaponName2 = $(this).data("need2");
    let weaponName3 = $(this).data("need3");
    let weaponName4 = $(this).data("need4");
    let weaponHash = $(this).data("weaponhash");
    let weaponPrice = $(this).data("weaponprice");
    $(".i").text("need:");
    $("#item1").text(weaponName1);
    $("#item2").text(weaponName2);
    $("#item3").text(weaponName3);
    $("#item4").text(weaponName4);
    $("#subtitle").text(weapon + " - " + weaponPrice + "$")
    currentWeapon = weaponHash;
    weaponRes1 = weaponName1;
    weaponRes2 = weaponName2;
    weaponRes3 = weaponName3;
    weaponRes4 = weaponName4;
    weaponPricee = weaponPrice;
    chooseWeapon(weapon, resources, weaponPrice);
})

$("#crafting-container").on("click", "#craftBtn", function () {
    $("#crafting-container").hide(500);
    $.post("https://rn-crafting/craft", JSON.stringify({ currentRequiredItem, currentWeapon, weaponRes1, weaponRes2, weaponRes3, weaponRes4, weaponPricee }));
    currentRequiredItem = null;
})


function chooseWeapon(weapon, resources, weaponPrice) {
    $.post("https://rn-crafting/chooseWeapon", JSON.stringify({ weapon, resources, weaponPrice }));
}

document.onkeyup = (e) => {
    const key = e.key;
    if (key == "Escape") {
        $('#crafting-container').hide(500);
        $("#usb-container").fadeOut();
        currentRequiredItem = null
        $.post("https://rn-crafting/close", JSON.stringify({}));
    }
};