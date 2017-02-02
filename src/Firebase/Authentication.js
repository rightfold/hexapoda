'use strict';

var Control_Monad_Aff = require('../Control.Monad.Aff');
var Data_Maybe = require('../Data.Maybe');

exports.userID = function(user) {
  return user.uid;
};

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

exports.currentUser = function() {
  var user = firebase.auth().currentUser;
  return user === null ? Data_Maybe.Nothing.value : new Data_Maybe.Just(user);
};

exports.signInWithPopup = function(provider) {
  return function(onSuccess, onError) {
    firebase.auth().signInWithPopup(provider)
      .then(function(response) { onSuccess({}); })
      .catch(function(error) { onError(error); });
    return Control_Monad_Aff.nonCanceler;
  };
};
