export const PrintButton = {
  mounted() {
    this.el.addEventListener("click", () => {
      window.print()
    })
  }
}
