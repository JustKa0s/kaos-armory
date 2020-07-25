$(document).ready(function () {
  window.addEventListener('message', function (event) {
    var item = event.data;
    if (item.show == true) {
      open();
    }
    if (item.show == false) {
      close()
    }
  });
  document.onkeyup = function (data) {
    if (data.which == 27) {
      $.post('http://kaos-armory/close', JSON.stringify({}));
    }
  };
});

$.post('http://kaos-armory/getConfigs', JSON.stringify({}), function (response) {
  if (response) {
    response.forEach(function (element, index) {
      $(".container").append(`
      <button class="knap" onclick="giveWeapon(${index})">${element.title}</button> <br><br>
    `);
      });
    }
  });


function open() {
  $(".container").fadeIn();
  $(".container").css("display", "block");
  $("#buttons").css("display", "block");
}

function giveWeapon(WeaponID) {
  $.post('http://kaos-armory/giveWeapon', JSON.stringify({
    WeaponID: WeaponID
  }));
}

function close() {
  $(".container").css("display", "none");
  $("#buttons").css("display", "none");
}