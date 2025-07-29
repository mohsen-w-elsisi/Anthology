import express from "express";
import fetchHTMLString from "./fetchHTMLString";
import generateBrief from "./generateBrief";

const app = express();
app.use(express.text());

const PORT = 8080;

app.get("/", async (req, res) => {
  const textUri = req.body;
  const HTMLString = await fetchHTMLString(textUri);
  const brief = generateBrief(HTMLString);
  res.json(brief);
});

app.listen(PORT, () => console.log(`listening on port ${PORT}`));
