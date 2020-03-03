import LiveValues
import RenderKit
import PixelKit
import Expression

extension PIXLang {
    
    public static func eval(code: String, with constants: [String: PIX & NODEOut], defaultResolution: Resolution?) throws -> PIX & NODEOut {
        var symbols: [AnyExpression.Symbol: AnyExpression.SymbolEvaluator] = [:]
        symbols[.function("rgb", arity: .exactly(3))] = { args in
            guard let vals: [Double] = args as? [Double] else {
                throw PIXLangError.badArg("arg type is array of floats")
            }
            return LiveColor(r: LiveFloat(vals[0]),
                             g: LiveFloat(vals[1]),
                             b: LiveFloat(vals[2]))
        }
        symbols[.function("rgba", arity: .exactly(4))] = { args in
            guard let vals: [Double] = args as? [Double] else {
                throw PIXLangError.badArg("arg type is array of floats")
            }
            return LiveColor(r: LiveFloat(vals[0]),
                             g: LiveFloat(vals[1]),
                             b: LiveFloat(vals[2]),
                             a: LiveFloat(vals[3]))
        }
        symbols[.function("hsv", arity: .exactly(3))] = { args in
            guard let vals: [Double] = args as? [Double] else {
                throw PIXLangError.badArg("arg type is array of floats")
            }
            return LiveColor(h: LiveFloat(vals[0]),
                             s: LiveFloat(vals[1]),
                             v: LiveFloat(vals[2]))
        }
        symbols[.function("hsva", arity: .exactly(4))] = { args in
            guard let vals: [Double] = args as? [Double] else {
                throw PIXLangError.badArg("arg type is array of floats")
            }
            return LiveColor(h: LiveFloat(vals[0]),
                             s: LiveFloat(vals[1]),
                             v: LiveFloat(vals[2]),
                             a: LiveFloat(vals[3]))
        }
        let colors: [String: LiveColor] = [
            "clear": .clear,
            "white": .white,
            "black": .black,
            "red": .red,
            "yellow": .yellow,
            "green": .green,
            "cyan": .cyan,
            "blue": .blue,
            "magenta": .magenta,
            "r": .red,
            "g": .green,
            "b": .blue,
        ]
        for color in colors {
            symbols[.variable(".\(color.key)")] = { _ in
                let colorPix = ColorPIX(at: .square(1))
                colorPix.color = color.value
                return colorPix
            }
        }
        for auto in AutoPIXGenerator.allCases {
            let name: String = auto.rawValue.replacingOccurrences(of: "pix", with: "")
            symbols[.function(name, arity: .any)] = { args in
                let res: Resolution = try PIXLang.res(from: args, defaultResolution: defaultResolution)
                let pix: PIXGenerator = auto.pixType.init(at: res)
                return pix
            }
        }
        for auto in AutoPIXSingleEffect.allCases {
            let name: String = auto.rawValue.replacingOccurrences(of: "pix", with: "")
            symbols[.function(name, arity: .exactly(1))] = { args in
                let pix: PIXSingleEffect = auto.pixType.init()
                pix.input = try PIXLang.argToPix(args[0])
                return pix
            }
        }
        for auto in AutoPIXMergerEffect.allCases {
            let name: String = auto.rawValue.replacingOccurrences(of: "pix", with: "")
            symbols[.function(name, arity: .exactly(2))] = { args in
                let pix: PIXMergerEffect = auto.pixType.init()
                pix.inputA = try PIXLang.argToPix(args[0])
                pix.inputB = try PIXLang.argToPix(args[1])
                return pix
            }
        }
        for auto in AutoPIXMultiEffect.allCases {
            let name: String = auto.rawValue.replacingOccurrences(of: "pix", with: "")
            symbols[.function(name, arity: .atLeast(1))] = { args in
                let pix: PIXMultiEffect = auto.pixType.init()
                pix.inputs = try args.map({ try PIXLang.argToPix($0) })
                return pix
            }
        }
        for blendMode in BlendMode.allCases {
            let infix: String = PIX.blendOperators.operatorName(of: blendMode)
            symbols[.infix(infix)] = { args in
                let blendPix = BlendPIX()
                blendPix.blendMode = blendMode
                blendPix.placement = .aspectFill
                blendPix.extend = .hold
                blendPix.inputA = try PIXLang.argToPix(args[0])
                blendPix.inputB = try PIXLang.argToPix(args[1])
                return blendPix
            }
        }
        symbols[.infix("->")] = { args in
            let displacePix = DisplacePIX()
            displacePix.distance = 1.0
            displacePix.placement = .aspectFill
            displacePix.extend = .hold
            displacePix.inputA = try PIXLang.argToPix(args[0])
            displacePix.inputB = try PIXLang.argToPix(args[1])
            return displacePix
        }
        symbols[.infix("~>")] = { args in
            let blurPix = BlurPIX()
            blurPix.radius = try PIXLang.argToVal(args[1])
            blurPix.input = try PIXLang.argToPix(args[0])
            return blurPix
        }
        let expression = AnyExpression(code, constants: constants, symbols: symbols)
        let pix: PIX & NODEOut = try PIXLang.argToPix(try expression.evaluate())
        return pix
    }
    
}
