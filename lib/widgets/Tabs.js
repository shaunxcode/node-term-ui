// Generated by CoffeeScript 1.3.3
(function() {
  var T, _,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  _ = require("underscore");

  _.mixin(require("underscore.string"));

  T = require("../TermUI");

  T.Tabs = (function(_super) {

    __extends(Tabs, _super);

    function Tabs(opts) {
      var _ref, _ref1, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7, _ref8;
      Tabs.__super__.constructor.call(this, opts);
      this.position = (_ref = opts.position) != null ? _ref : "top";
      this.x = (_ref1 = opts.x) != null ? _ref1 : 1;
      this.y = (_ref2 = opts.y) != null ? _ref2 : 1;
      this.setItems((_ref3 = opts.items) != null ? _ref3 : []);
      this.lineColor = (_ref4 = opts.lineColor) != null ? _ref4 : T.C.g;
      this.textColor = (_ref5 = opts.textColor) != null ? _ref5 : T.C.g;
      this.spaceBefore = (_ref6 = opts.spaceBefore) != null ? _ref6 : 1;
      this.spaceBetween = (_ref7 = opts.spaceBetween) != null ? _ref7 : 1;
      this.activeTabs = (_ref8 = opts.activeTab) != null ? _ref8 : false;
    }

    Tabs.prototype.setItems = function(items) {
      var item, tab, _i, _len, _ref;
      this.width = 0;
      this.items = (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = items.length; _i < _len; _i++) {
          tab = items[_i];
          if (!_.isArray(tab)) {
            _results.push([tab, tab]);
          } else {
            _results.push(tab);
          }
        }
        return _results;
      })();
      _ref = this.items;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        item = _ref[_i];
        this.width += item[1].length + 3;
      }
      this.activeTab = false;
      this._tabBounds = {};
      return this._focussed = false;
    };

    Tabs.prototype.setActiveTab = function(tab) {
      this.activeTab = tab;
      this.draw();
      return this;
    };

    Tabs.prototype.draw = function() {
      var tab, tabId, width, x, y, _i, _len, _ref, _ref1;
      if (this.hidden) {
        return;
      }
      x = this.x;
      y = this.y;
      T.saveCursor().pos(x, y);
      _ref = this.items;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        tab = _ref[_i];
        _ref1 = tab, tabId = _ref1[0], tab = _ref1[1];
        width = tab.length;
        this._tabBounds[tabId] = {
          x: x,
          y: y,
          w: width,
          height: 3
        };
        if (this.position === "top") {
          T.pos(x, y + 2).out(T.B(1, 1, 0, 0)).pos(x + 1, y + 1).out(T.B(0, 0, 1, 1)).pos(x + 1, y).out(T.B(0, 1, 0, 1)).pos(x + 2, y).out(_.repeat(T.B(1, 1, 0, 0), width)).out(T.B(1, 0, 0, 1)).pos(x + 2, y + 1).out(tab).out(T.B(0, 0, 1, 1)).pos(x + 2, y + 2);
          T.pos(x + 1, y + 2);
          if (tabId === this.activeTab) {
            T.out(T.B(1, 0, 1, 0)).out(_.repeat(" ", width)).out(T.B(0, 1, 1, 0));
          } else {
            T.out(T.B(1, 1, 1, 0)).out(_.repeat(T.B(1, 1, 0, 0), width)).out(T.B(1, 1, 1, 0));
          }
        } else if (this.position === "bottom") {
          T.pos(x, y).out(T.B(1, 1, 0, 0)).pos(x + 1, y + 1).out(T.B(0, 0, 1, 1)).pos(x + 1, y + 2).out(T.B(0, 1, 1, 0)).pos(x + 2, y + 2).out(_.repeat(T.B(1, 1, 0, 0), width)).out(T.B(1, 0, 1, 0)).pos(x + 2, y + 1).out(tab).out(T.B(0, 0, 1, 1));
          T.pos(x + 1, y);
          if (tabId === this.activeTab) {
            T.out(T.B(1, 0, 0, 1)).out(_.repeat(" ", width)).out(T.B(0, 1, 0, 1));
          } else {
            T.out(T.B(1, 1, 0, 1)).out(_.repeat(T.B(1, 1, 0, 0), width)).out(T.B(1, 1, 0, 1));
          }
        }
        x += width + 3;
      }
      T.restoreCursor();
      return Tabs.__super__.draw.call(this);
    };

    Tabs.prototype.hitTest = function(x, y) {
      var bounds, tabId, _ref;
      T.pos(15, 15).out("x:" + x + ", y:" + y);
      _ref = this._tabBounds;
      for (tabId in _ref) {
        bounds = _ref[tabId];
        if (((bounds.x <= x && x <= (bounds.x + bounds.w - 1))) && ((bounds.y <= y && y <= (bounds.y + bounds.h - 1)))) {
          this.activeTab = tabId;
          this.draw();
          return true;
        }
      }
    };

    Tabs.prototype._label = function(item, fg, bg) {
      var bounds, tab, tabId;
      if (this.hidden) {
        return;
      }
      tabId = item[0], tab = item[1];
      bounds = this._tabBounds[tabId];
      return T.pos(bounds.x + 2, bounds.y + 1).saveFg().saveBg().fg(fg).bg(bg).out(tab).restoreFg().restoreBg();
    };

    Tabs.prototype.unfocusTab = function() {
      if (this._focussed !== false) {
        return this._label(this.items[this._focussed], T.C.g, T.C.k);
      }
    };

    Tabs.prototype.focusTab = function() {
      return this._label(this.items[this._focussed], T.C.k, T.C.g);
    };

    Tabs.prototype.focus = function() {
      Tabs.__super__.focus.call(this);
      return this.handleTab();
    };

    Tabs.prototype.handleTab = function() {
      this.unfocusTab();
      if (this._focussed === false) {
        this._focussed = 0;
      } else {
        this._focussed++;
      }
      if (this._focussed === this.items.length) {
        this._focussed = false;
        return false;
      }
      return this.focusTab();
    };

    Tabs.prototype.onKey_space = function() {
      if (this._focussed !== false) {
        this.activeTab = this.items[this._focussed][0];
        this.draw();
        this.focusTab();
        return this.emit("activeTab", this.activeTab, this.items[this._focussed][1]);
      }
    };

    Tabs.prototype.onKey_left = function() {
      this.unfocusTab();
      if (this._focussed === 0) {
        this._focussed = this.items.length - 1;
      } else {
        this._focussed--;
      }
      return this.focusTab();
    };

    Tabs.prototype.onKey_right = function() {
      this.unfocusTab();
      this._focussed++;
      if (this._focussed === this.items.length) {
        this._focussed = 0;
      }
      return this.focusTab();
    };

    return Tabs;

  })(T.Widget);

}).call(this);
