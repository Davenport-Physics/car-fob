
var current_vehicle_id = -1

function KeyboardHandler() 
{
    switch (event.key) {

        case "Escape":
            $.post("http://car-fob/EscapeCarFob", JSON.stringify({}))
            $(".carfob-container").hide()
            $(".car-list-container").hide()
            $("body").hide()
            break;

    }
}

function ShowCarFob(vehicle_id)
{

    $(".car-list-container").hide()
    current_vehicle_id = vehicle_id
    console.log(current_vehicle_id)
    $(".carfob-container").show()

}

function ShowCarOptions(owned_vehicles) 
{
    current_vehicle_id = -1;

    var selectText = document.getElementById("SelectCar")
    selectText.innerHTML = "";
    for (var i = 0;i < owned_vehicles.length;i++) {

        var option = document.createElement("li")
        option.setAttribute("onclick", "ShowCarFob({id})".replace("{id}", owned_vehicles[i].id))
        var option_text = document.createTextNode(owned_vehicles[i].model)
        option.appendChild(option_text)
        selectText.appendChild(option)

    }

    $(".car-list-container").show()
    $("body").show();
}

function NUIEvent(event)
{
    if (event.data.type == "ToggleCarFob") {
        ShowCarOptions(event.data.owned_vehicles)
    }
}

function LockDoor() 
{
    $.post("http://car-fob/LockDoors", JSON.stringify({"vehicle_id":current_vehicle_id}))
}

function UnlockDoor() 
{
    $.post("http://car-fob/UnlockDoors", JSON.stringify({"vehicle_id":current_vehicle_id}))
}

function ToggleEngine() 
{
    $.post("http://car-fob/ToggleEngine", JSON.stringify({"vehicle_id":current_vehicle_id}))
}

function ToggleAlarm()
{
    $.post("http://car-fob/ToggleAlarm", JSON.stringify({"vehicle_id":current_vehicle_id}))
}

$(function() 
{
    window.addEventListener('message', NUIEvent);
    window.addEventListener('keydown', KeyboardHandler)
})
