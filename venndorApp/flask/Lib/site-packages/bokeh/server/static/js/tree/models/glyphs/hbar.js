var Glyph, HBar, HBarView, Quad, _, hittest, p, rbush,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

_ = require("underscore");

rbush = require("rbush");

Quad = require("./quad");

Glyph = require("./glyph");

hittest = require("../../common/hittest");

p = require("../../core/properties");

HBarView = (function(superClass) {
  extend(HBarView, superClass);

  function HBarView() {
    return HBarView.__super__.constructor.apply(this, arguments);
  }

  HBarView.prototype._map_data = function() {
    var i, j, ref, vleft, vright, vy;
    vy = this.renderer.ymapper.v_map_to_target(this._y);
    this.sy = this.plot_view.canvas.v_vy_to_sy(vy);
    vright = this.renderer.xmapper.v_map_to_target(this._right);
    vleft = this.renderer.xmapper.v_map_to_target(this._left);
    this.sright = this.plot_view.canvas.v_vx_to_sx(vright);
    this.sleft = this.plot_view.canvas.v_vx_to_sx(vleft);
    this.stop = [];
    this.sbottom = [];
    this.sh = this.sdist(this.renderer.ymapper, this._y, this._height, 'center');
    for (i = j = 0, ref = this.sy.length; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
      this.stop.push(this.sy[i] - this.sh[i] / 2);
      this.sbottom.push(this.sy[i] + this.sh[i] / 2);
    }
    return null;
  };

  HBarView.prototype._render = function(ctx, indices, arg) {
    var i, j, len, results, sbottom, sleft, sright, stop;
    sleft = arg.sleft, sright = arg.sright, stop = arg.stop, sbottom = arg.sbottom;
    results = [];
    for (j = 0, len = indices.length; j < len; j++) {
      i = indices[j];
      if (isNaN(sleft[i] + stop[i] + sright[i] + sbottom[i])) {
        continue;
      }
      if (this.visuals.fill.doit) {
        this.visuals.fill.set_vectorize(ctx, i);
        ctx.fillRect(sleft[i], stop[i], sright[i] - sleft[i], sbottom[i] - stop[i]);
      }
      if (this.visuals.line.doit) {
        ctx.beginPath();
        ctx.rect(sleft[i], stop[i], sright[i] - sleft[i], sbottom[i] - stop[i]);
        this.visuals.line.set_vectorize(ctx, i);
        results.push(ctx.stroke());
      } else {
        results.push(void 0);
      }
    }
    return results;
  };

  return HBarView;

})(Glyph.View);

HBar = (function(superClass) {
  extend(HBar, superClass);

  function HBar() {
    return HBar.__super__.constructor.apply(this, arguments);
  }

  HBar.prototype.default_view = HBarView;

  HBar.prototype.type = 'HBar';

  HBar.mixins(['line', 'fill']);

  HBar.define({
    y: [p.NumberSpec],
    height: [p.DistanceSpec],
    left: [p.NumberSpec, 0],
    right: [p.NumberSpec]
  });

  return HBar;

})(Glyph.Model);

module.exports = {
  Model: HBar,
  View: HBarView
};
