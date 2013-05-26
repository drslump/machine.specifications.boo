namespace Machine.Specifications.Boo


macro cleanup:
    field = field_factory('cleanup_', 'Machine.Specifications.Cleanup', cleanup.Body)
    field.LexicalInfo = cleanup.LexicalInfo
    yield field
