// Generated code from Butter Knife. Do not modify!
package com.dragondev.n2kanji.fragment;

import android.widget.TextView;
import butterknife.Unbinder;
import butterknife.internal.Finder;
import butterknife.internal.ViewBinder;
import java.lang.IllegalStateException;
import java.lang.Object;
import java.lang.Override;

public class KanjiDetailFragment$$ViewBinder<T extends KanjiDetailFragment> implements ViewBinder<T> {
  @Override
  public Unbinder bind(Finder finder, T target, Object source) {
    return new InnerUnbinder<>(target, finder, source);
  }

  protected static class InnerUnbinder<T extends KanjiDetailFragment> implements Unbinder {
    protected T target;

    protected InnerUnbinder(T target, Finder finder, Object source) {
      this.target = target;

      target.tvTitleKanji = finder.findRequiredViewAsType(source, 2131296455, "field 'tvTitleKanji'", TextView.class);
      target.tvTitleOnyomi = finder.findRequiredViewAsType(source, 2131296457, "field 'tvTitleOnyomi'", TextView.class);
      target.tvTitleKunyomi = finder.findRequiredViewAsType(source, 2131296456, "field 'tvTitleKunyomi'", TextView.class);
    }

    @Override
    public void unbind() {
      T target = this.target;
      if (target == null) throw new IllegalStateException("Bindings already cleared.");

      target.tvTitleKanji = null;
      target.tvTitleOnyomi = null;
      target.tvTitleKunyomi = null;

      this.target = null;
    }
  }
}
