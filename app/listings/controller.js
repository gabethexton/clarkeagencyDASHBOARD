'use strict';

app.controller('controller', ['$http', '$window', function ($http, $window) {
    var vm = this;

    vm.sessionStorage = $window.sessionStorage;

    vm.post = function (address, city, state, zip, price, description, notes) {
        $http.post('https://clarkeagency.herokuapp.com/listings', {
            address: address,
            city: city,
            state: state,
            zip: zip,
            price: price,
            description: description,
            notes: notes
        })

        .then(function (response) {
                console.log(response);
                // TODO: log response id here and maybe store in sessionStorage
                vm.message = "New Listing successfully posted.";

            })
            .catch(function (err) {
                console.log(err);
                // TODO: present better error handling
                vm.message = "Failed to post New Listing";
            });
    };

}]);
