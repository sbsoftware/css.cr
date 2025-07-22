module CSS::Enums
  enum Display
    # Outside
    Block
    Inline
    RunIn

    # Inside
    Flow
    FlowRoot
    Table
    Flex
    Grid
    Ruby

    # Box generation
    Contents
    None

    # List item
    ListItem

    # Internal
    TableRowGroup
    TableHeaderGroup
    TableFooterGroup
    TableRow
    TableCell
    TableColumnGroup
    TableColumn
    TableCaption
    RubyBase
    RubyText
    RubyBaseContainer
    RubyTextContainer

    # Legacy
    InlineBlock
    InlineTable
    InlineFlex
    InlineGrid
  end
end
