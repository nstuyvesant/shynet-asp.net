namespace SHY
{
    using System;
    using System.Globalization;
    using System.Web.UI;
    using System.Web.UI.WebControls;

    [ToolboxData(@"<{0}:GridPager runat=""server"" PersistentDataSource=true></{0}:GridPager>")]
    public class GridPager : UserControl
    {
        #region Properties

        /// <summary>
        ///     Gets or sets the number of results.
        /// </summary>
        /// <value> The number of results. </value>
        public int NumberOfResults { get; set; }

        /// <summary>
        ///     Gets or sets the results to show per page.
        /// </summary>
        /// <value> The results to show per page. </value>
        public int ResultsToShowPerPage { get; set; }

        /// <summary>
        ///     Gets or sets the page links to show for pagination links.
        /// </summary>
        /// <value> The page links to show. </value>
        public int PageLinksToShow { get; set; }

        /// <summary>
        ///     Gets or sets a value indicating whether [show first and last].
        /// </summary>
        /// <value>
        ///     <c>true</c> if [show first and last]; otherwise, <c>false</c> .
        /// </value>
        public bool ShowFirstAndLast { get; set; }

        /// <summary>
        ///     Gets or sets a value indicating whether [show next and previous].
        /// </summary>
        /// <value>
        ///     <c>true</c> if [show next and previous]; otherwise, <c>false</c> .
        /// </value>
        public bool ShowNextAndPrevious { get; set; }

        /// <summary>
        ///     Gets or sets the next text.
        /// </summary>
        /// <value> The next text. </value>
        public string NextText { get; set; }

        /// <summary>
        ///     Gets or sets the previous text.
        /// </summary>
        /// <value> The previous text. </value>
        public string PreviousText { get; set; }

        /// <summary>
        ///     Gets or sets the first text.
        /// </summary>
        /// <value> The first text. </value>
        public string FirstText { get; set; }

        /// <summary>
        ///     Gets or sets the last text.
        /// </summary>
        /// <value> The last text. </value>
        public string LastText { get; set; }

        public GridView TheGrid { get; private set; }

        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            ResultsToShowPerPage = 5;

            Control control = Parent;
            while (control != null)
            {
                if (control is GridView)
                {
                    TheGrid = (GridView) control;
                    break;
                }
                control = control.Parent;
            }
        }

        /// <summary>
        ///     Called by the ASP.NET page framework to notify server controls that use composition-based implementation to create any child controls they contain in preparation for posting back or rendering.
        /// </summary>
        protected override void CreateChildControls()
        {
            Controls.Add(new Literal { Text = "<ul class=\"pagination\">" });

            int lowNumber = Math.Min(
                        Math.Max(0, TheGrid.PageIndex - ( PageLinksToShow/2 )),
                        Math.Max(0, TheGrid.PageCount - PageLinksToShow + 1)
                    );

            int highNumber = Math.Min(TheGrid.PageCount, lowNumber + PageLinksToShow);

            if ((highNumber - lowNumber < PageLinksToShow) && (TheGrid.PageCount >= PageLinksToShow))
                lowNumber--;

            if (ShowFirstAndLast)
            {
                AddPagerLink(FirstText ?? "&laquo;", "First", TheGrid.PageIndex > 0);
            }

            if (ShowNextAndPrevious)
            {
                AddPagerLink(PreviousText ?? "&lt;", "Prev", TheGrid.PageIndex > 0);
            }

            for (int i = lowNumber; i < highNumber; i++)
            {
                AddPagerLink((i + 1).ToString(CultureInfo.InvariantCulture), (i + 1).ToString(CultureInfo.InvariantCulture), TheGrid.PageIndex != i, true);
            }

            if (ShowNextAndPrevious)
            {
                AddPagerLink(NextText ?? "&gt;", "Next", TheGrid.PageIndex < TheGrid.PageCount - 1);
            }

            if (ShowFirstAndLast)
            {
                AddPagerLink(LastText ?? "&raquo;", "Last", TheGrid.PageIndex < TheGrid.PageCount - 1);
            }

            Controls.Add(new Literal {Text = "</ul>"});
            
        }

        /// <summary>
        /// Adds the link for the page (and next/last etc) or a label if its a deactivated link
        /// </summary>
        /// <param name="text">Text to be displayed.</param>
        /// <param name="commandArgument">The command argument.</param>
        /// <param name="isEnabled">Whether the pager link can be clicked.</param>
        /// <param name="isPageNumber">Renders pager link as numeric.</param>
        private void AddPagerLink(String text, string commandArgument, bool isEnabled, bool isPageNumber = false)
        {
            if (isEnabled)
            {
                Controls.Add(new Literal { Text = "<li>" });
                LinkButton button = new LinkButton
                {
                    ID = "Page" + text,
                    CommandName = "Page",
                    CommandArgument = commandArgument,
                    Text = text
                };
                Controls.Add(button);
            }
            else
            {
                string template = "<li class=\"{class}\">";
                if (isPageNumber)
                    template = template.Replace("{class}", "active");
                else
                    template = template.Replace("{class}", "disabled");
                Controls.Add(new Literal { Text = template });
                Controls.Add(new HyperLink { Text = text });
            }

            Controls.Add(new Literal {Text = "</li>"});
        }
    }

}