# TEMP 파일 경로
TEMP_FILE="tempI18N.swift"

# Output 파일 경로
OUTPUT_FILE=Linky/Core/Sources/Util/Localize/I18N.swift

# JSON 파일 경로
JSON_FILE="${PROJECT_DIR}/Resources/Localize/Localizable.xcstrings"

# make TEMP_FILE
touch "$TEMP_FILE"

echo "public struct I18N {" >> "$TEMP_FILE"

keys=($(jq -r '.strings | keys[]' "$JSON_FILE"))

for key in "${keys[@]}"; do
    echo "    public static let "$key" = \"$key\".localized" >> "$TEMP_FILE" 
done

echo "}" >> "$TEMP_FILE"

cat "$TEMP_FILE" > "$OUTPUT_FILE"
rm "$TEMP_FILE"

#osascript -e 'tell app "System Events" to display dialog "'"${OUTPUT_FILE}"'"'

