import LiveValues
import RenderKit
import PixelKit
import Expression

extension PIXLang {

    public static func assign(_ value: String, at property: String, to pix: PIX) throws -> Bool {
        for auto in AutoPIXGenerator.allCases {
            guard String(describing: type(of: pix)) == String(describing: auto.pixType) else { continue }
            let autoPix = pix as! PIXGenerator
            let allProperties: [String] = auto.allAutoPropertyNames(for: autoPix)
            guard allProperties.contains(property) else {
                for iProperty in allProperties { print(".\(iProperty)") }
                throw PIXLangError.assign("property \(property) not found")
            }
            let floats: [AutoLiveFloatProperty] = auto.autoLiveFloats(for: autoPix)
            let ints: [AutoLiveIntProperty] = auto.autoLiveInts(for: autoPix)
            let bools: [AutoLiveBoolProperty] = auto.autoLiveBools(for: autoPix)
            let points: [AutoLivePointProperty] = auto.autoLivePoints(for: autoPix)
            let sizes: [AutoLiveSizeProperty] = auto.autoLiveSizes(for: autoPix)
            let rects: [AutoLiveRectProperty] = auto.autoLiveRects(for: autoPix)
            let colors: [AutoLiveColorProperty] = auto.autoLiveColors(for: autoPix)
            let enums: [AutoEnumProperty] = auto.autoEnums(for: autoPix)
            if try PIXLang.assign(property: property, value: value, floats: floats, ints: ints, bools: bools, points: points, sizes: sizes, rects: rects, colors: colors, enums: enums) {
                return true
            }
        }
        for auto in AutoPIXSingleEffect.allCases {
            guard String(describing: type(of: pix)) == String(describing: auto.pixType) else { continue }
            let autoPix = pix as! PIXSingleEffect
            let allProperties: [String] = auto.allAutoPropertyNames(for: autoPix)
            guard allProperties.contains(property) else {
                for iProperty in allProperties { print(".\(iProperty)") }
                throw PIXLangError.assign("property \(property) not found")
            }
            let floats: [AutoLiveFloatProperty] = auto.autoLiveFloats(for: autoPix)
            let ints: [AutoLiveIntProperty] = auto.autoLiveInts(for: autoPix)
            let bools: [AutoLiveBoolProperty] = auto.autoLiveBools(for: autoPix)
            let points: [AutoLivePointProperty] = auto.autoLivePoints(for: autoPix)
            let sizes: [AutoLiveSizeProperty] = auto.autoLiveSizes(for: autoPix)
            let rects: [AutoLiveRectProperty] = auto.autoLiveRects(for: autoPix)
            let colors: [AutoLiveColorProperty] = auto.autoLiveColors(for: autoPix)
            let enums: [AutoEnumProperty] = auto.autoEnums(for: autoPix)
            if try PIXLang.assign(property: property, value: value, floats: floats, ints: ints, bools: bools, points: points, sizes: sizes, rects: rects, colors: colors, enums: enums) {
                return true
            }
        }
        for auto in AutoPIXMergerEffect.allCases {
            guard String(describing: type(of: pix)) == String(describing: auto.pixType) else { continue }
            let autoPix = pix as! PIXMergerEffect
            let allProperties: [String] = auto.allAutoPropertyNames(for: autoPix)
            guard allProperties.contains(property) else {
                for iProperty in allProperties { print(".\(iProperty)") }
                throw PIXLangError.assign("property \(property) not found")
            }
            let floats: [AutoLiveFloatProperty] = auto.autoLiveFloats(for: autoPix)
            let ints: [AutoLiveIntProperty] = auto.autoLiveInts(for: autoPix)
            let bools: [AutoLiveBoolProperty] = auto.autoLiveBools(for: autoPix)
            let points: [AutoLivePointProperty] = auto.autoLivePoints(for: autoPix)
            let sizes: [AutoLiveSizeProperty] = auto.autoLiveSizes(for: autoPix)
            let rects: [AutoLiveRectProperty] = auto.autoLiveRects(for: autoPix)
            let colors: [AutoLiveColorProperty] = auto.autoLiveColors(for: autoPix)
            let enums: [AutoEnumProperty] = auto.autoEnums(for: autoPix)
            if try PIXLang.assign(property: property, value: value, floats: floats, ints: ints, bools: bools, points: points, sizes: sizes, rects: rects, colors: colors, enums: enums) {
                return true
            }
        }
        for auto in AutoPIXMultiEffect.allCases {
            guard String(describing: type(of: pix)) == String(describing: auto.pixType) else { continue }
            let autoPix = pix as! PIXMultiEffect
            let allProperties: [String] = auto.allAutoPropertyNames(for: autoPix)
            guard allProperties.contains(property) else {
                for iProperty in allProperties { print(".\(iProperty)") }
                throw PIXLangError.assign("property \(property) not found")
            }
            let floats: [AutoLiveFloatProperty] = auto.autoLiveFloats(for: autoPix)
            let ints: [AutoLiveIntProperty] = auto.autoLiveInts(for: autoPix)
            let bools: [AutoLiveBoolProperty] = auto.autoLiveBools(for: autoPix)
            let points: [AutoLivePointProperty] = auto.autoLivePoints(for: autoPix)
            let sizes: [AutoLiveSizeProperty] = auto.autoLiveSizes(for: autoPix)
            let rects: [AutoLiveRectProperty] = auto.autoLiveRects(for: autoPix)
            let colors: [AutoLiveColorProperty] = auto.autoLiveColors(for: autoPix)
            let enums: [AutoEnumProperty] = auto.autoEnums(for: autoPix)
            if try PIXLang.assign(property: property, value: value, floats: floats, ints: ints, bools: bools, points: points, sizes: sizes, rects: rects, colors: colors, enums: enums) {
                return true
            }
        }
        return false
    }

    static func assign(property: String,
                       value: String,
                       floats: [AutoLiveFloatProperty],
                       ints: [AutoLiveIntProperty],
                       bools: [AutoLiveBoolProperty],
                       points: [AutoLivePointProperty],
                       sizes: [AutoLiveSizeProperty],
                       rects: [AutoLiveRectProperty],
                       colors: [AutoLiveColorProperty],
                       enums: [AutoEnumProperty]) throws -> Bool {
        if let float = floats.first(where: { $0.name == property }) {
            let val: Double = try Expression(value).evaluate()
            float.value = LiveFloat(val)
            return true
        }
        if let int = ints.first(where: { $0.name == property }) {
            let val: Double = try Expression(value).evaluate()
            int.value = LiveInt(Int(val))
            return true
        }
        if let bool = bools.first(where: { $0.name == property }) {
            if ["true", "True", "YES"].contains(value) {
                bool.value = true
            } else if ["false", "False", "NO"].contains(value) {
                bool.value = false
            } else {
                let val: Double = try Expression(value).evaluate()
                bool.value = LiveBool(val > 0.0)
            }
            return true
        }
        if let point = points.first(where: { $0.name == property }) {
            let vals: [Double] = try AnyExpression(value).evaluate()
            guard vals.count == 2 else {
                throw PIXLangError.assign("double array needs 2 values [x,y]")
            }
            point.value = LivePoint(x: LiveFloat(vals[0]),
                                    y: LiveFloat(vals[1]))
            return true
        }
        if let size = sizes.first(where: { $0.name == property }) {
            let vals: [Double] = try AnyExpression(value).evaluate()
            guard vals.count == 2 else {
                throw PIXLangError.assign("double array needs 2 values [w,h]")
            }
            size.value = LiveSize(w: LiveFloat(vals[0]),
                                  h: LiveFloat(vals[1]))
            return true
        }
        if let rect = rects.first(where: { $0.name == property }) {
            let vals: [Double] = try AnyExpression(value).evaluate()
            guard vals.count == 4 else {
                throw PIXLangError.assign("double array needs 4 values [x,y,w,h]")
            }
            rect.value = LiveRect(x: LiveFloat(vals[0]),
                                  y: LiveFloat(vals[1]),
                                  w: LiveFloat(vals[2]),
                                  h: LiveFloat(vals[3]))
            return true
        }
        if let color = colors.first(where: { $0.name == property }) {
            let vals: [Double] = try AnyExpression(value).evaluate()
            guard vals.count == 4 else {
                throw PIXLangError.assign("double array needs 4 values [r,g,b,a]")
            }
            color.value = LiveColor(r: LiveFloat(vals[0]),
                                    g: LiveFloat(vals[1]),
                                    b: LiveFloat(vals[2]),
                                    a: LiveFloat(vals[3]))
            return true
        }
        if let _enum = enums.first(where: { $0.name == property }) {
            guard value.starts(with: ".") else {
                throw PIXLangError.assign("start the enum value with a dot (.)")
            }
            func list() {
                for _case in _enum.cases {
                    print(".\(_case)")
                }
            }
            if value == "." {
                list()
                return true
            }
            guard _enum.cases.map({ ".\($0)" }).contains(value) else {
                list()
                throw PIXLangError.assign("enum value \(value) not found")
            }
            _enum.value = String(value.dropFirst())
            return true
        }
        return false
    }
    
    public static func propertyNames(for pix: PIX & NODEOut) -> [String]? {
        for auto in AutoPIXGenerator.allCases {
            guard String(describing: type(of: pix)) == String(describing: auto.pixType) else { continue }
            return auto.allAutoPropertyNames(for: pix as! PIXGenerator)
        }
        for auto in AutoPIXSingleEffect.allCases {
            guard String(describing: type(of: pix)) == String(describing: auto.pixType) else { continue }
            return auto.allAutoPropertyNames(for: pix as! PIXSingleEffect)
        }
        for auto in AutoPIXMergerEffect.allCases {
            guard String(describing: type(of: pix)) == String(describing: auto.pixType) else { continue }
            return auto.allAutoPropertyNames(for: pix as! PIXMergerEffect)
        }
        for auto in AutoPIXMultiEffect.allCases {
            guard String(describing: type(of: pix)) == String(describing: auto.pixType) else { continue }
            return auto.allAutoPropertyNames(for: pix as! PIXMultiEffect)
        }
        return nil
    }
    
}
