// Generated code from Butter Knife. Do not modify!
package com.dragondev.n2kanji.fragment;

import android.support.v7.widget.RecyclerView;
import butterknife.Unbinder;
import butterknife.internal.Finder;
import butterknife.internal.ViewBinder;
import java.lang.IllegalStateException;
import java.lang.Object;
import java.lang.Override;

public class KanjiListFragment$$ViewBinder<T extends KanjiListFragment> implements ViewBinder<T> {
  @Override
  public Unbinder bind(Finder finder, T target, Object source) {
    return new InnerUnbinder<>(target, finder, source);
  }

  protected static class InnerUnbinder<T extends KanjiListFragment> implements Unbinder {
    protected T target;

    protected InnerUnbinder(T target, Finder finder, Object source) {
      this.target = target;

      target.kanjiRecyclerView = finder.findRequiredViewAsType(source, 2131296353, "field 'kanjiRecyclerView'", RecyclerView.class);
    }

    @Override
    public void unbind() {
      T target = this.target;
      if (target == null) throw new IllegalStateException("Bindings already cleared.");

      target.kanjiRecyclerView = null;

      this.target = null;
    }
  }
}
