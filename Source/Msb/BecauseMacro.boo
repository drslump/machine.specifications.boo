namespace Machine.Specifications.Boo


macro because:
    field = field_factory('of_', 'Machine.Specifications.Because', because.Body)
    field.LexicalInfo = because.LexicalInfo
    yield field

macro because_of:
    field = field_factory('of_', 'Machine.Specifications.Because', because_of.Body)
    field.LexicalInfo = because_of.LexicalInfo
    yield field
