export const PrintButton = {
  mounted() {
    console.log("mounted")
    this.el.addEventListener("click", () => {
      console.log("hello")
      window.print()
    })
  }
}
