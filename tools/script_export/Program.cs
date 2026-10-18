// Exports every script class of an Unreal package as UnrealScript, one .uc per class.
//
//     dotnet run --project tools/script_export -- <package.upk> <outdir>
//
// Prints classes=<n> errors=<n>. A class counts as an error when UELib throws
// on it or leaves one of its error markers in the output. The other packages
// in the input's folder are read first for the element types of their array
// properties, which a package's default properties need when the array is
// declared in another package, and for the native functions' tokens.
using UELib;
using UELib.Core;
using UELib.Types;

if (args.Length != 2)
{
    Console.Error.WriteLine("usage: script_export <package.upk> <outdir>");
    return 2;
}
if (!File.Exists(args[0]))
{
    Console.Error.WriteLine($"missing input: {args[0]}");
    return 2;
}

// Console-cooked packages (here Xbox 360) strip UProperty's category and
// array enum; without this UELib misreads every property.
#pragma warning disable CS0612
UnrealConfig.Platform = UnrealConfig.CookedPlatform.Console;
#pragma warning restore CS0612

UnrealConfig.VariableTypes = new Dictionary<string, Tuple<string, PropertyType>>();
var natives = new Dictionary<ushort, NativeTableItem>();
var folder = Path.GetDirectoryName(Path.GetFullPath(args[0]));
foreach (var file in Directory.GetFiles(folder).Where(ScriptExport.IsPackage).Order())
{
    foreach (var obj in ScriptExport.Load(file).Objects)
    {
        if (obj is UArrayProperty array && array.InnerProperty != null)
        {
            UnrealConfig.VariableTypes.TryAdd(array.Name.ToString(),
                Tuple.Create(array.Outer?.Name.ToString() ?? "", array.InnerProperty.Type));
        }
        else if (obj is UFunction function && function.NativeToken != 0)
        {
            natives.TryAdd(function.NativeToken, ScriptExport.Native(function));
        }
    }
}

// Native functions and operators by their token, so calls read as names, not __NFUN_<n>__.
var package = ScriptExport.Load(args[0], new NativesTablePackage
{
    NativeTableList = natives.Values.OrderBy(n => n.ByteToken).ToList(),
    NativeTokenMap = natives,
});
Directory.CreateDirectory(args[1]);

int classes = 0, errors = 0;
foreach (var obj in package.Objects)
{
    if (obj is not UClass cls || obj.ExportTable == null)
    {
        continue;
    }
    classes++;
    string text;
    try
    {
        text = cls.Decompile();
    }
    catch (Exception e)
    {
        text = $"// script_export: decompile failed: {e.GetType().Name}: {e.Message}\n";
    }
    if (ScriptExport.HasError(text))
    {
        errors++;
        Console.WriteLine($"error: {cls.Name}");
    }
    File.WriteAllText(Path.Combine(args[1], cls.Name + ".uc"), text);
}
Console.WriteLine($"classes={classes} errors={errors}");
return 0;

static class ScriptExport
{
    // The markers UELib leaves where decompilation went wrong, and ours.
    public static readonly string[] Markers =
    {
        "/* ERROR", "!MISMATCHING", "Array type was not detected", "script_export: decompile failed",
    };

    public static bool HasError(string text) => Markers.Any(text.Contains);

    // Cooked packages drop an operator's friendly name ("!="), leaving its
    // internal one ("NotEqual_ObjectObject"); the part before '_' gives it back.
    static readonly Dictionary<string, string> Operators = new()
    {
        ["Not"] = "!", ["EqualEqual"] = "==", ["NotEqual"] = "!=", ["AndAnd"] = "&&", ["XorXor"] = "^^",
        ["OrOr"] = "||", ["MultiplyEqual"] = "*=", ["DivideEqual"] = "/=", ["AddEqual"] = "+=",
        ["SubtractEqual"] = "-=", ["AddAdd"] = "++", ["SubtractSubtract"] = "--", ["Complement"] = "~",
        ["Subtract"] = "-", ["Add"] = "+", ["Multiply"] = "*", ["Divide"] = "/", ["Percent"] = "%",
        ["MultiplyMultiply"] = "**", ["Less"] = "<", ["Greater"] = ">", ["LessEqual"] = "<=",
        ["GreaterEqual"] = ">=", ["EqualTilde"] = "~=", ["LessLess"] = "<<", ["GreaterGreater"] = ">>",
        ["GreaterGreaterGreater"] = ">>>", ["And"] = "&", ["Xor"] = "^", ["Or"] = "|", ["Concat"] = "$",
        ["At"] = "@", ["ConcatEqual"] = "$=", ["AtEqual"] = "@=",
    };

    public static NativeTableItem Native(UFunction function)
    {
        var item = new NativeTableItem(function);
        if (item.Type != FunctionType.Function)
        {
            var prefix = function.Name.ToString().Split('_')[0];
            item.Name = Operators.GetValueOrDefault(prefix, prefix);
        }
        return item;
    }

    public static bool IsPackage(string path) =>
        new[] { ".xxx", ".upk", ".u" }.Contains(Path.GetExtension(path).ToLowerInvariant());

    // UELib reports objects it cannot read on the console; that goes to stderr.
    public static UnrealPackage Load(string path, NativesTablePackage natives = null)
    {
        var stdout = Console.Out;
        Console.SetOut(Console.Error);
        try
        {
            var package = UnrealLoader.LoadPackage(path, FileAccess.Read);
            package.NTLPackage = natives;
            package.InitializePackage(UnrealPackage.InitFlags.All);
            return package;
        }
        finally
        {
            Console.SetOut(stdout);
        }
    }
}
