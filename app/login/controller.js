'use strict';

app.controller('controller',['$http','$window',function($http, $window){
  var vm = this;

  vm.sessionStorage = $window.sessionStorage;

  vm.auth = function(user, password){
    $http.post('https://clarkeagency.herokuapp.com/auth/login',{username:user, password:password})

    .then(function(response){
      console.log(response);
      $window.sessionStorage.token = response.data.token;
      vm.message = "Logged in successful";
      console.log(vm.message);

    })
    .catch(function(err){
      console.log(err);
      delete $window.sessionStorage.token;
      vm.message = "Log in unsuccessful";
      console.log(vm.message);
    });
};

  vm.logout = function(){
    delete $window.sessionStorage.token;
    vm.message = "Log out successful";
    console.log(vm.message);
};

}]);
