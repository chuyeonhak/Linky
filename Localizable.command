# TEMP 파일 경로
TEMP_FILE="tempI18N.swift"

# Output 파일 경로
OUTPUT_FILE=Linky/Core/Sources/Util/Localize/I18N.swift

# JSON 파일 경로
JSON_FILE="Linky/Linky/Resources/Localize/Localizable.xcstrings"

# make TEMP_FILE
touch "$TEMP_FILE"

echo "public enum I18N {" >> "$TEMP_FILE"

keys=($(jq -r '.strings | keys[]' "$JSON_FILE"))

for key in "${keys[@]}"; do
ko=$(jq -r '.strings.'${key}'.localizations.ko.stringUnit.value' "$JSON_FILE" | tr -d '\n')
    echo "    /// ${ko}" >> "$TEMP_FILE"
    echo "    public static let "$key" = \"$key\".localized" >> "$TEMP_FILE" 
done

#for key in "${keys[@]}"; do
#en=$(jq -r '.strings.'${key}'.localizations.en.stringUnit.value' "$JSON_FILE" | tr -d '\n')
#    echo "${en}" >> "$TEMP_FILE"
#done
echo "}" >> "$TEMP_FILE"

cat "$TEMP_FILE" > "$OUTPUT_FILE"
rm "$TEMP_FILE"

#osascript -e 'tell app "System Events" to display dialog "'"${JSON_FILE}"'"'

