(function(){

  if (window.RubySwarm) { return; }

  var submitTimeout = 5;

  var curHeartbeat;
  var beatRate = 20;

  var curKeepalive;
  var keepaliveRate = 120;

  // Expose the RubySwarm API
  window.RubySwarm = {
    heartbeat: function(){
      if (curHeartbeat) { clearTimeout( curHeartbeat ); }
      curHeartbeat = setTimeout(submitTimeout, beatRate * 1000);
    },
    keepalive: function(){
      if (curKeepalive) return;
      curKeepalive = setTimeout(submitKeepalive, keepaliveRate * 1000);
    },
    serialize: function(){
      console.log('serialize');
    }
  };

  // Prevent careless things from executing
  window.print = window.confirm = window.alert = window.open = function(){};

  // CoreTest (SproutCore)
  if ( typeof CoreTest !== "undefined" && CoreTest.Runner ) {

    var originalPlanDidFinish = CoreTest.Runner.planDidFinish,
        originalPlanDidRecord = CoreTest.Runner.planDidRecord;

    CoreTest.Runner.planDidFinish = function(plan, r) {
      var ret = originalPlanDidFinish.apply(this, arguments);
      submitSuccess({
        fail: r.failed,
        error: r.errors,
        total: r.total
      });
      return ret;
    };

    CoreTest.Runner.planDidRecord = function() {
      var ret = originalPlanDidRecord.apply(this, arguments);
      window.RubySwarm.heartbeat();
      window.RubySwarm.keepalive();
      return ret;
    };

  }

  function submit(params){
    console.log('submit', params);
  }

  function submitSuccess(params){
    if (curHeartbeat) { clearTimeout(curHeartbeat); }
    if (curKeepalive) { clearTimeout(curKeepalive); }
    submit(params);
  }

  function submitTimeout(params){
    submitSuccess({ fail: -1, total: -1 });
  }

  function submitKeepalive(){
    if (curKeepalive) {
      clearTimeout(curKeepalive);
      curKeepalive = null;
    }
    submit({ keepalive: true });
  }

})();
