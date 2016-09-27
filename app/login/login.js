'use strict';

var app = angular.module('Login', []);


app.factory('authInterceptor', ['$q', '$window', function ($q, $window) {
  return {
    request: function (config) {
      config.headers = config.headers || {};
      if ($window.sessionStorage.token) {
        config.headers.Authorization = 'Bearer ' + $window.sessionStorage.token;
        window.location.href = 'app/listings/listings.html';
      }
      return config;
    },
    response: function (response) {
      if (response.status === 401) {
        // TODO handle no auth sitch
        console.log("User not authenticated.");
      }

      window.location.href = '../../app/listings/listings.html';
      return response || $q.when(response);
    }
  };
}]);

app.config(['$httpProvider', function ($httpProvider) {
  $httpProvider.interceptors.push('authInterceptor');
}]);
