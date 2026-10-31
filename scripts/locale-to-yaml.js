// Converts standard.csv to locale/[code].yaml
// Inteded to be used only once to get started with the yaml translation system

import { readFileSync, writeFileSync } from "node:fs";
import * as CSV from "csv-parse/sync";
import * as YAML from "js-yaml";

const LOCALE_KEYS = ["01_en", "02_ru", "03_pt-br", "04_es-es", "05_de", "06_fr-fr", "07_it", "08_pl", "09_zh-cn", "10_jp", "11_ko"];

const raw = CSV.parse(readFileSync("files/standard.csv", "utf8"), {
	relaxColumnCount: true,
	relaxQuotes: true,
});

const locale = {};
for (const key of LOCALE_KEYS) {
	locale[key] = {};
}

for (const line of raw) {
	const key = line[0];
    for (let idx = 0; idx < LOCALE_KEYS.length; idx++) {
      const lang = LOCALE_KEYS[idx];
      const value = line[idx + 1];

      if (!value) continue;

      locale[lang][key] = value.replace(/\\n/g, "\n");
    }
}

for (const key in locale) {
	writeFileSync(
		`locale/${key}.yaml`,
		YAML.dump(locale[key], {
			lineWidth: -1,
			quoteStyle: "double"
		})
	);
}
