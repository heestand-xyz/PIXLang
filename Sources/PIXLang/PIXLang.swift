public struct PIXLang {}

enum PIXLangError: Error {
    case badArg(String)
    case pixInitFail(String)
    case unknownArg(Any)
    case assign(String)
}
