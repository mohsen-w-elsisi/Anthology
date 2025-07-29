import { Readability } from "@mozilla/readability";
import { JSDOM } from "jsdom";
import { ArticleBrief } from "./types";

function generateBrief(HTMLString: string): ArticleBrief {
  const dom = new JSDOM(HTMLString).window.document;
  const brief = new Readability(dom).parse();
  return {
    url: new URL("https://example.com"),
    title: brief.title,
    bodyHtml: brief.content,
  };
}

export default generateBrief;
