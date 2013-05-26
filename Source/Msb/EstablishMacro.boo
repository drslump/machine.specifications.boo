namespace Machine.Specifications.Boo


macro establish:
    field = field_factory('context_', 'Machine.Specifications.Establish', establish.Body)
    field.LexicalInfo = establish.LexicalInfo
    yield field


macro context:
    field = field_factory('context_', 'Machine.Specifications.Establish', context.Body)
    field.LexicalInfo = context.LexicalInfo
    yield field

