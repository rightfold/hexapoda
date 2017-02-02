'use strict';

var Control_Monad_Aff = require('../Control.Monad.Aff');

exports.newGitHubProvider = function() {
  return new firebase.auth.GithubAuthProvider();
};

exports.addScope = function(provider) {
  return function(scope) {
    return function() {
      provider.addScope(scope);
    };
  };
};

exports.signInWithPopup = function(provider) {
  return function(onSuccess, onError) {
    firebase.auth().signInWithPopup(provider)
      .then(function(response) { onSuccess({user: response.user}); })
      .catch(function(error) { onError(error); });
    return Control_Monad_Aff.nonCanceler;
  };
};
