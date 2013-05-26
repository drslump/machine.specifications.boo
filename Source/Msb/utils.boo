namespace Machine.Specifications.Boo

import System.Text
import System.Globalization
import Boo.Lang.Compiler.Ast


def sanitize_text(text as string):
    # Remove diacritics
    text = text.Normalize(NormalizationForm.FormD)
    sb = StringBuilder()
    for ch in text:
        if CharUnicodeInfo.GetUnicodeCategory(ch) != UnicodeCategory.NonSpacingMark:
            sb.Append(ch)
    text = sb.ToString().Normalize(NormalizationForm.FormC)

    # Convert UTF8 to ASCII
    bytes = Encoding.UTF8.GetBytes(text)
    bytes = Encoding.Convert(Encoding.UTF8, Encoding.ASCII, bytes)
    text = Encoding.ASCII.GetString(bytes)

    # Replace spaces with underscores
    text = /\s+/.Replace(text, '_')

    # Remove everything that is not a valid ident character
    text = /[^_a-zA-Z0-9]/.Replace(text, string.Empty)

    # Make sure it doesn't start with a number
    if char.IsNumber(text[0]):
        text = '_' + text

    return text


def field_factory(name as string, type as string, init as Block) as Field:
    field = Field()
    field.Visibility = TypeMemberModifiers.Protected
    field.Name = sanitize_text(name)
    field.Type = SimpleTypeReference(Name: type)
    if init and len(init.Statements):
        field.Initializer = BlockExpression(Body: init.Clone())

    return field
