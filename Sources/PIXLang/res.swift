import RenderKit

extension PIXLang {
    
    static func res(from args: [Any], defaultResolution: Resolution?) throws -> Resolution {
        if args.count == 0 {
            guard let res = defaultResolution else {
                throw PIXLangError.pixInitFail("no default resolution specified")
            }
            return res
        } else if args.count == 1 {
            let arg: Any = args[0]
            if let resStr: String = arg as? String {
                guard resStr.contains("x") else {
                    throw PIXLangError.pixInitFail("bad res string, x not found. format: 1920x1080")
                }
                let parts: [String] = resStr.split(separator: "x").map({"\($0)"})
                guard parts.count == 2 else {
                    throw PIXLangError.pixInitFail("bad res x count. format: 1920x1080")
                }
                guard let w: Int = Int(parts[0]) else {
                    throw PIXLangError.pixInitFail("bad res width. format: 1920x1080")
                }
                guard let h: Int = Int(parts[1]) else {
                    throw PIXLangError.pixInitFail("bad res height. format: 1920x1080")
                }
                return .custom(w: w, h: h)
            } else if let val: Double = arg as? Double {
                return .square(Int(val))
            } else {
                throw PIXLangError.pixInitFail("res arg \(arg) is not a number")
            }
        } else if args.count == 2 {
            let argW: Any = args[0]
            let argH: Any = args[0]
            if let valW: Double = argW as? Double, let valH: Double = argH as? Double {
                return .custom(w: Int(valW), h: Int(valH))
            } else {
                throw PIXLangError.pixInitFail("res args \(args) is not numbers")
            }
        } else {
            throw PIXLangError.pixInitFail("res arg count outside range of 0...2")
        }
    }
    
}
