'use strict';

var Control_Monad_Aff = require('../Control.Monad.Aff');

exports.once = function(ref) {
  return function(onSuccess, onError) {
    firebase.database().ref(ref).once('value')
      .then(function(value) { onSuccess(value.val()); })
      .catch(function(error) { onError(error); });
    return Control_Monad_Aff.nonCanceler;
  };
};
