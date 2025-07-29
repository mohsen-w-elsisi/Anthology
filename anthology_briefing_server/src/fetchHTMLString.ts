async function fetchHTMLString(textUri: string): Promise<string> {
  const url = new URL(textUri);
  const response = await fetch(url);
  const HTMLString = await response.text();
  return HTMLString;
}

export default fetchHTMLString;
