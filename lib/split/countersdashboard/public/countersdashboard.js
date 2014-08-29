function confirmResetCounter() {
  var agree = confirm("This will reset the value for this counter, experiment and alternative?");
  return agree ? true : false;
}

function confirmDeleteCounter() {
  var agree = confirm("Are you sure you want to delete this counter and all its data?");
  return agree ? true : false;
}
