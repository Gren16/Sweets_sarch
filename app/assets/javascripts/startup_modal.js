document.addEventListener("DOMContentLoaded", function() {
  var modal = document.getElementById("startupModal");
  if (modal) {
    var modalInstance = new bootstrap.Modal(modal);
    modalInstance.show();
  }
});