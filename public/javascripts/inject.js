(function(){

  if (window.RubySwarmRunner) { return; }

  var submitTimeout = 5;

  var curKeepalive;
  var keepaliveRate = 10; // Needs to be less than timeout in run.html

  // Expose the RubySwarm API
  window.RubySwarmRunner = {
    keepalive: function(){
      if (curKeepalive) return;
      curKeepalive = setTimeout(keepalive, keepaliveRate * 1000);
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
      window.RubySwarmRunner.keepalive();
      return ret;
    };

  // QUnit (jQuery)
	// http://docs.jquery.com/QUnit
  } else if ( typeof QUnit !== "undefined" ) {
		QUnit.done = function(fail, total){
			submitSuccess({
				fail: fail,
				error: 0,
				total: total
			});
		};

		QUnit.log = window.RubySwarmRunner.keepalive;
		window.RubySwarmRunner.keepalive();

		window.RubySwarmRunner.serialize = function(){
			// Clean up the HTML (remove any un-needed test markup)
			remove("nothiddendiv");
			remove("loadediframe");
			remove("dl");
			remove("main");

			// Show any collapsed results
			var ol = document.getElementsByTagName("ol");
			for ( var i = 0; i < ol.length; i++ ) {
				ol[i].style.display = "block";
			}

			return trimSerialize();
		};
  }

  function submit(params){
    if (window.top.RubySwarm && window.top.RubySwarm.submitTest) {
      window.top.RubySwarm.submitTest(params);
    } else {
      console.log('submit', params);
    }
  }

  function submitSuccess(params){
    if (curKeepalive) { clearTimeout(curKeepalive); }
    submit(params);
  }

  function submitTimeout(params){
    submitSuccess({ fail: -1, total: -1 });
  }

  function keepalive(){
    if (curKeepalive) {
      clearTimeout(curKeepalive);
      curKeepalive = null;
    }
    if (window.top.RubySwarm && window.top.RubySwarm.keepalive) {
      window.top.RubySwarm.keepalive();
    } else {
      console.log('keepalive');
    }
  }

})();
