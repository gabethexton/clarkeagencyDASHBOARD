'use strict';

app.controller('controller', ['$http', '$window', function ($http, $window) {
    var vm = this;

    vm.sessionStorage = $window.sessionStorage;

    vm.post = function (category, subcategory, title, /*agent_id,*/ text) {
        $http.post('https://clarkeagency.herokuapp.com/resources', {
            category: category,
            subcategory: subcategory,
            title: title,
            // TODO: GET AGENT ID FROM sessionStorage! uncomment above
            // agent_id: agent_id,
            text: text
        })

        .then(function (response) {
                console.log(response);
                // TODO: log response id here and maybe store in sessionStorage
                vm.message = "New Resource successfully posted.";

            })
            .catch(function (err) {
                console.log(err);
                // TODO: present better error handling
                vm.message = "Failed to post New Resource";
            });
    };

}]);
