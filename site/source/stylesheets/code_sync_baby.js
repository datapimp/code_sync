/*
 *= require_tree ./vendor
 *= require ./code-sync/codemirror
 *= require ./code-sync/editor
 *= require ./code-sync/editor-panel
 *= require ./code-sync/editor-utility
 *= require ./code-sync/toolbars
 *= require ./code-sync/buttons
 *= require_tree ./src/plugins
 *= require_self
*/

.card-view {
  .card {
    display: none;
    &.active {
      display: block;
    }
  }
}