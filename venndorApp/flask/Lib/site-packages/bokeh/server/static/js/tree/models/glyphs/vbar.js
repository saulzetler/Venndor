var Glyph, Quad, VBar, VBarView, _, hittest, p, rbush,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

_ = require("underscore");

rbush = require("rbush");

Quad = require("./quad");

Glyph = require("./glyph");

hittest = require("../../common/hittest");

p = require("../../core/properties");

VBarView = (function(superClass) {
  extend(VBarView, superClass);

  function VBarView() {
    return VBarView.__super__.constructor.apply(this, arguments);
  }

  VBarView.prototype._map_data = function() {
    var i, j, ref, vbottom, vtop;
    this.sx = this.renderer.xmapper.v_map_to_target(this._x);
    vtop = this.renderer.ymapper.v_map_to_target(this._top);
    vbottom = this.renderer.ymapper.v_map_to_target(this._bottom);
    this.stop = this.plot_view.canvas.v_vy_to_sy(vtop);
    this.sbottom = this.plot_view.canvas.v_vy_to_sy(vbottom);
    this.sleft = [];
    this.sright = [];
    this.sw = this.sdist(this.renderer.xmapper, this._x, this._width, 'center');
    for (i = j = 0, ref = this.sx.length; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
      this.sleft.push(this.sx[i] - this.sw[i] / 2);
      this.sright.push(this.sx[i] + this.sw[i] / 2);
    }
    return null;
  };

  VBarView.prototype._render = function(ctx, indices, arg) {
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

  return VBarView;

})(Glyph.View);

VBar = (function(superClass) {
  extend(VBar, superClass);

  function VBar() {
    return VBar.__super__.constructor.apply(this, arguments);
  }

  VBar.prototype.default_view = VBarView;

  VBar.prototype.type = 'VBar';

  VBar.mixins(['line', 'fill']);

  VBar.define({
    x: [p.NumberSpec],
    width: [p.DistanceSpec],
    top: [p.NumberSpec],
    bottom: [p.NumberSpec, 0]
  });

  return VBar;

})(Glyph.Model);

module.exports = {
  Model: VBar,
  View: VBarView
};
