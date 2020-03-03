import LiveValues
import RenderKit
import PixelKit
import Expression

extension PIXLang {
    
    static func argToVal(_ arg: Any) throws -> LiveFloat {
        if let val: Double = arg as? Double {
            return LiveFloat(val)
        }
        throw PIXLangError.unknownArg(arg)
    }
    
    static func argToPix(_ arg: Any) throws -> PIX & NODEOut {
        if let pix = arg as? PIX & NODEOut {
            return pix
        }
        if let color: LiveColor = argToColor(arg) {
            let colorPix = ColorPIX(at: .square(1))
            colorPix.color = color
            return colorPix
        }
        throw PIXLangError.unknownArg(arg)
    }
    
    static func argToColor(_ arg: Any) -> LiveColor? {
        if let color: LiveColor = arg as? LiveColor {
            return color
        }
        var color: LiveColor?
        if let val = arg as? Double {
            color = LiveColor(lum: LiveFloat(val))
        } else if let vals = arg as? [Double] {
            if vals.count == 2 {
                color = LiveColor(lum: LiveFloat(vals[0]),
                                  a: LiveFloat(vals[1]))
            } else if vals.count == 3 {
                color = LiveColor(r: LiveFloat(vals[0]),
                                  g: LiveFloat(vals[1]),
                                  b: LiveFloat(vals[2]))
            } else if vals.count == 4 {
                color = LiveColor(r: LiveFloat(vals[0]),
                                  g: LiveFloat(vals[1]),
                                  b: LiveFloat(vals[2]),
                                  a: LiveFloat(vals[3]))
            }
        }
        return color
    }
    
}
